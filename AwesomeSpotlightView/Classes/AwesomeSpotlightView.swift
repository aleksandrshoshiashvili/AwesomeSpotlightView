//
//  AwesomeSpotlightView.swift
//  AwesomeSpotlightView
//
//  Created by Alex Shoshiashvili on 24.02.17.
//  Copyright © 2017 Alex Shoshiashvili. All rights reserved.
//

import UIKit

// MARK: - AwesomeSpotlightViewDelegate

@objc public protocol AwesomeSpotlightViewDelegate {
    @objc optional func spotlightView(_ spotlightView: AwesomeSpotlightView, willNavigateToIndex index: Int)
    @objc optional func spotlightView(_ spotlightView: AwesomeSpotlightView, didNavigateToIndex index: Int)
    @objc optional func spotlightViewWillCleanup(_ spotlightView: AwesomeSpotlightView, atIndex index: Int)
    @objc optional func spotlightViewDidCleanup(_ spotlightView: AwesomeSpotlightView)
}

@objcMembers
public class AwesomeSpotlightView: UIView {
    
    public var delegate: AwesomeSpotlightViewDelegate?
    
    // MARK: - private variables
    
    private static let kAnimationDuration = 0.3
    private static let kCutoutRadius: CGFloat = 4.0
    private static let kMaxLabelWidth = 280.0
    private static let kMaxLabelSpacing: CGFloat = 35.0
    private static let kEnableContinueLabel = false
    private static let kEnableSkipButton = false
    private static let kEnableArrowDown = false
    private static let kShowAllSpotlightsAtOnce = false
    private static let kTextLabelFont = UIFont.systemFont(ofSize: 20.0)
    private static let kContinueLabelFont = UIFont.systemFont(ofSize: 13.0)
    private static let kSkipButtonFont = UIFont.boldSystemFont(ofSize: 13.0)
    private static let kSkipButtonLastStepTitle = "Done".localized
    
    private var spotlightMask = CAShapeLayer()
    private var arrowDownImageView = UIImageView()
    private var arrowDownSize = CGSize(width: 12, height: 18)
    private var delayTime: TimeInterval = 0.35
    private var hitTestPoints: [CGPoint] = []
    
    // MARK: - public variables
    
    public var spotlightsArray: [AwesomeSpotlight] = []
    public var textLabel = UILabel()
    public var continueLabel = UILabel()
    public var skipSpotlightButton = UIButton()
    public var animationDuration = kAnimationDuration
    public var cutoutRadius: CGFloat = kCutoutRadius
    public var maxLabelWidth = kMaxLabelWidth
    public var labelSpacing: CGFloat = kMaxLabelSpacing
    public var enableArrowDown = kEnableArrowDown
    public var showAllSpotlightsAtOnce = kShowAllSpotlightsAtOnce
    public var continueButtonModel = AwesomeTabButton(title: "Continue".localized, font: kContinueLabelFont, isEnable: kEnableContinueLabel)
    public var skipButtonModel = AwesomeTabButton(title: "Skip".localized, font: kSkipButtonFont, isEnable: kEnableSkipButton)
    public var skipButtonLastStepTitle = kSkipButtonLastStepTitle
    
    public var spotlightMaskColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6) {
        didSet {
            spotlightMask.fillColor = spotlightMaskColor.cgColor
        }
    }
    
    public var textLabelFont = kTextLabelFont {
        didSet {
            textLabel.font = textLabelFont
        }
    }
    
    public var isShowed: Bool {
        return currentIndex != 0
    }
    
    public var currentIndex = 0
    
    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(frame: CGRect, spotlight: [AwesomeSpotlight]) {
        self.init(frame: frame)
        
        self.spotlightsArray = spotlight
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        setupMask()
        setupTouches()
        setupTextLabel()
        setupArrowDown()
        isHidden = true
    }
    
    private func setupMask() {
        spotlightMask.fillRule = CAShapeLayerFillRule.evenOdd
        spotlightMask.fillColor = spotlightMaskColor.cgColor
        layer.addSublayer(spotlightMask)
    }
    
    private func setupTouches() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AwesomeSpotlightView.userDidTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupTextLabel() {
        let textLabelRect = CGRect(x: 0, y: 0, width: maxLabelWidth, height: 0)
        textLabel = UILabel(frame: textLabelRect)
        textLabel.backgroundColor = .clear
        textLabel.textColor = .white
        textLabel.font = textLabelFont
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.alpha = 0
        addSubview(textLabel)
    }
    
    private func setupArrowDown() {
        let arrowDownIconName = "arrowDownIcon"
        if let bundlePath = Bundle.main.path(forResource: "AwesomeSpotlightViewBundle", ofType: "bundle") {
            if let _ = Bundle(path: bundlePath)?.path(forResource: arrowDownIconName, ofType: "png") {
                let arrowDownImage = UIImage(named: arrowDownIconName, in: Bundle(path: bundlePath), compatibleWith: nil)
                arrowDownImageView = UIImageView(image: arrowDownImage)
                arrowDownImageView.alpha = 0
                addSubview(arrowDownImageView)
            }
        }
    }
    
    private func setupContinueLabel() {
        let continueLabelWidth = skipButtonModel.isEnable ? 0.7 * bounds.size.width : bounds.size.width
        let continueLabelHeight: CGFloat = 30.0
        
        if #available(iOS 11.0, *) {
            continueLabel = UILabel(frame: CGRect(x: 0, y: bounds.size.height - continueLabelHeight - safeAreaInsets.bottom, width: continueLabelWidth, height: continueLabelHeight))
        } else {
            continueLabel = UILabel(frame: CGRect(x: 0, y: bounds.size.height - continueLabelHeight, width: continueLabelWidth, height: continueLabelHeight))
        }
        
        continueLabel.font = continueButtonModel.font
        continueLabel.textAlignment = .center
        continueLabel.text = continueButtonModel.title
        continueLabel.alpha = 0
        continueLabel.backgroundColor = continueButtonModel.backgroundColor ?? .white
        addSubview(continueLabel)
    }
    
    private func setupSkipSpotlightButton() {
        let continueLabelWidth = 0.7 * bounds.size.width
        let skipSpotlightButtonWidth = bounds.size.width - continueLabelWidth
        let skipSpotlightButtonHeight: CGFloat = 30.0
        
        if #available(iOS 11.0, *) {
            skipSpotlightButton = UIButton(frame: CGRect(x: continueLabelWidth, y: bounds.size.height - skipSpotlightButtonHeight - safeAreaInsets.bottom, width: skipSpotlightButtonWidth, height: skipSpotlightButtonHeight))
        } else {
            skipSpotlightButton = UIButton(frame: CGRect(x: continueLabelWidth, y: bounds.size.height - skipSpotlightButtonHeight, width: skipSpotlightButtonWidth, height: skipSpotlightButtonHeight))
        }
        
        skipSpotlightButton.addTarget(self, action: #selector(AwesomeSpotlightView.skipSpotlight), for: .touchUpInside)
        skipSpotlightButton.setTitle(skipButtonModel.title, for: [])
        skipSpotlightButton.titleLabel?.font = skipButtonModel.font
        skipSpotlightButton.alpha = 0
        skipSpotlightButton.tintColor = .white
        skipSpotlightButton.backgroundColor = skipButtonModel.backgroundColor ?? .clear
        addSubview(skipSpotlightButton)
    }
    
    // MARK: - Touches
    
    @objc func userDidTap(_ recognizer: UITapGestureRecognizer) {
        goToSpotlightAtIndex(index: currentIndex + 1)
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        let localPoint = convert(point, from: self)
        hitTestPoints.append(localPoint)
        
        guard currentIndex < spotlightsArray.count else {
            return view
        }
        
        let currentSpotlight = spotlightsArray[currentIndex]
        if currentSpotlight.rect.contains(localPoint), currentSpotlight.isAllowPassTouchesThroughSpotlight {
            if hitTestPoints.filter({ $0 == localPoint }).count == 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                    self.cleanup()
                })
            }
            return nil
        }
        
        return view
    }
    
    // MARK: - Presenter
    
    public func start() {
        alpha = 0
        isHidden = false
        textLabel.font = textLabelFont
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 1
        }) { (finished) in
            self.goToFirstSpotlight()
        }
    }
    
    private func goToFirstSpotlight() {
        goToSpotlightAtIndex(index: 0)
    }
    
    private func goToSpotlightAtIndex(index: Int) {
        if index >= spotlightsArray.count {
            cleanup()
        } else if showAllSpotlightsAtOnce {
            showSpotlightsAllAtOnce()
        } else {
            showSpotlightAtIndex(index: index)
        }
    }
    
    private func showSpotlightsAllAtOnce() {
        if let firstSpotlight = spotlightsArray.first {
            continueButtonModel.isEnable = false
            skipButtonModel.isEnable = false
            
            setCutoutToSpotlight(spotlight: firstSpotlight)
            animateCutoutToSpotlights(spotlights: spotlightsArray)
            currentIndex = spotlightsArray.count
        }
    }
    
    private func showSpotlightAtIndex(index: Int) {
        currentIndex = index
        
        let currentSpotlight = spotlightsArray[index]
        
        delegate?.spotlightView?(self, willNavigateToIndex: index)
        
        showTextLabel(spotlight: currentSpotlight)
        
        showArrowIfNeeded(spotlight: currentSpotlight)
        
        if currentIndex == 0 {
            setCutoutToSpotlight(spotlight: currentSpotlight)
        }
        
        animateCutoutToSpotlight(spotlight: currentSpotlight)
        
        showContinueLabelIfNeeded(index: index)
        showSkipButtonIfNeeded(index: index)
    }
    
    private func showArrowIfNeeded(spotlight: AwesomeSpotlight) {
        if enableArrowDown {
            arrowDownImageView.frame = CGRect(origin: CGPoint(x: center.x - 6, y: spotlight.rect.origin.y - 18 - 16), size: arrowDownSize)
            UIView.animate(withDuration: animationDuration, animations: {
                self.arrowDownImageView.alpha = 1
            })
        }
    }
    
    private func showTextLabel(spotlight: AwesomeSpotlight) {
        textLabel.alpha = 0
        calculateTextPositionAndSizeWithSpotlight(spotlight: spotlight)
        UIView.animate(withDuration: animationDuration) {
            self.textLabel.alpha = 1
        }
    }
    
    private func showContinueLabelIfNeeded(index: Int) {
        if continueButtonModel.isEnable {
            if index == 0 {
                setupContinueLabel()
                UIView.animate(withDuration: animationDuration, delay: delayTime, options: .curveLinear, animations: {
                    self.continueLabel.alpha = 1
                })
            } else if index >= spotlightsArray.count - 1 && continueLabel.alpha != 0 {
                continueLabel.alpha = 0
                continueLabel.removeFromSuperview()
            }
        }
    }
    
    private func showSkipButtonIfNeeded(index: Int) {
        if skipButtonModel.isEnable && index == 0 {
            setupSkipSpotlightButton()
            UIView.animate(withDuration: animationDuration, delay: delayTime, options: .curveLinear, animations: {
                self.skipSpotlightButton.alpha = 1
            })
        } else if skipSpotlightButton.isEnabled && index == spotlightsArray.count - 1 {
            skipSpotlightButton.setTitle(skipButtonLastStepTitle, for: .normal)
        }
    }
    
    @objc func skipSpotlight() {
        goToSpotlightAtIndex(index: spotlightsArray.count)
    }
    
    private func skipAllSpotlights() {
        goToSpotlightAtIndex(index: spotlightsArray.count)
    }
    
    // MARK: Helper
    
    private func calculateRectWithMarginForSpotlight(_ spotlight: AwesomeSpotlight) -> CGRect {
        var rect = spotlight.rect
        
        rect.size.width += spotlight.margin.left + spotlight.margin.right
        rect.size.height += spotlight.margin.bottom + spotlight.margin.top
        
        rect.origin.x = rect.origin.x - (spotlight.margin.left + spotlight.margin.right) / 2.0
        rect.origin.y = rect.origin.y - (spotlight.margin.top + spotlight.margin.bottom) / 2.0
        
        return rect
    }
    
    private func calculateTextPositionAndSizeWithSpotlight(spotlight: AwesomeSpotlight) {
        textLabel.frame = CGRect(x: 0, y: 0, width: maxLabelWidth, height: 0)
        textLabel.attributedText = spotlight.showedText
        
        if enableArrowDown && currentIndex == 0 {
            labelSpacing += 18
        }
        
        textLabel.sizeToFit()
        
        let rect = calculateRectWithMarginForSpotlight(spotlight)
        
        var y = rect.origin.y + rect.size.height + labelSpacing
        let bottomY = y + textLabel.frame.size.height + labelSpacing
        if bottomY > bounds.size.height {
            y = rect.origin.y - labelSpacing - textLabel.frame.size.height
        }
        
        let x : CGFloat = CGFloat(floor(bounds.size.width - textLabel.frame.size.width) / 2.0)
        textLabel.frame = CGRect(origin: CGPoint(x: x, y: y), size: textLabel.frame.size)
    }
    
    // MARK: - Cutout and Animate
    
    private func cutoutToSpotlight(spotlight: AwesomeSpotlight, isFirst : Bool = false) -> UIBezierPath {
        var rect = calculateRectWithMarginForSpotlight(spotlight)
        
        if isFirst {
            let x = floor(spotlight.rect.origin.x + (spotlight.rect.size.width / 2.0))
            let y = floor(spotlight.rect.origin.y + (spotlight.rect.size.height / 2.0))
            
            let center = CGPoint(x: x, y: y)
            rect = CGRect(origin: center, size: CGSize.zero)
        }
        
        let spotlightPath = UIBezierPath(rect: bounds)
        var cutoutPath = UIBezierPath()
        
        switch spotlight.shape {
        case .rectangle:
            cutoutPath = UIBezierPath(rect: rect)
        case .roundRectangle:
            cutoutPath = UIBezierPath(roundedRect: rect, cornerRadius: cutoutRadius)
        case .circle:
            cutoutPath = UIBezierPath(ovalIn: rect)
        }
        
        spotlightPath.append(cutoutPath)
        return spotlightPath
    }
    
    private func cutoutToSpotlightCGPath(spotlight: AwesomeSpotlight, isFirst : Bool = false) -> CGPath {
        return cutoutToSpotlight(spotlight: spotlight, isFirst: isFirst).cgPath
    }
    
    private func setCutoutToSpotlight(spotlight: AwesomeSpotlight) {
        spotlightMask.path = cutoutToSpotlightCGPath(spotlight: spotlight, isFirst: true)
    }
    
    private func animateCutoutToSpotlight(spotlight: AwesomeSpotlight) {
        let path = cutoutToSpotlightCGPath(spotlight: spotlight)
        animateCutoutWithPath(path: path)
    }
    
    private func animateCutoutToSpotlights(spotlights: [AwesomeSpotlight]) {
        let spotlightPath = UIBezierPath(rect: bounds)
        for spotlight in spotlights {
            var cutoutPath = UIBezierPath()
            switch spotlight.shape {
            case .rectangle:
                cutoutPath = UIBezierPath(rect: spotlight.rect)
            case .roundRectangle:
                cutoutPath = UIBezierPath(roundedRect: spotlight.rect, cornerRadius: cutoutRadius)
            case .circle:
                cutoutPath = UIBezierPath(ovalIn: spotlight.rect)
            }
            spotlightPath.append(cutoutPath)
        }
        animateCutoutWithPath(path: spotlightPath.cgPath)
    }
    
    private func animateCutoutWithPath(path: CGPath) {
        let animationKeyPath = "path"
        let animation = CABasicAnimation(keyPath: animationKeyPath)
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.fromValue = spotlightMask.path
        animation.toValue = path
        spotlightMask.add(animation, forKey: animationKeyPath)
        spotlightMask.path = path
    }
    
    // MARK: - Cleanup
    
    private func cleanup() {
        delegate?.spotlightViewWillCleanup?(self, atIndex: currentIndex)
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
                self.currentIndex = 0
                self.textLabel.alpha = 0
                self.continueLabel.alpha = 0
                self.skipSpotlightButton.alpha = 0
                self.hitTestPoints = []
                self.delegate?.spotlightViewDidCleanup?(self)
            }
        }
    }
    
    // MARK: - Objective-C Support Function
    // Objective-C provides support function because it does not correspond to struct
    
    public func setContinueButtonEnable(_ isEnable:Bool) {
        self.continueButtonModel.isEnable = isEnable
    }
    
    public func setSkipButtonEnable(_ isEnable:Bool) {
        self.skipButtonModel.isEnable = isEnable
    }
}

extension AwesomeSpotlightView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        delegate?.spotlightView?(self, didNavigateToIndex: currentIndex)
    }
}
