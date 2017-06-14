//
//  AwesomeSpotlightView.swift
//  AwesomeSpotlightView
//
//  Created by Alex Shoshiashvili on 24.02.17.
//  Copyright © 2017 Alex Shoshiashvili. All rights reserved.
//

import UIKit
//import QuartzCore

@objc protocol AwesomeSpotlightViewDelegate {
  @objc optional func spotlightView(spotlightView : AwesomeSpotlightView, willNavigateToIndex index: Int)
  @objc optional func spotlightView(spotlightView : AwesomeSpotlightView, didNavigateToIndex index: Int)
  @objc optional func spotlightViewWillCleanup(spotlightView : AwesomeSpotlightView)
  @objc optional func spotlightViewDidCleanup(spotlightView : AwesomeSpotlightView)
}

class AwesomeSpotlightView: UIView {
  
  var delegate : AwesomeSpotlightViewDelegate?
  
  // MARK: - private variables
  
  private static let kAnimationDuration = 0.3
  private static let kCutoutRadius : CGFloat = 4.0
  private static let kMaxLabelWidth = 280.0
  private static let kMaxLabelSpacing : CGFloat = 35.0
  private static let kEnableContinueLabel = false
  private static let kEnableSkipButton = false
  private static let kEnableArrowDown = false
  private static let kShowAllSpotlightsAtOnce = false
  private static let kTextLabelFont = UIFont.systemFont(ofSize: 20.0)
  private static let kContinueLabelFont = UIFont.systemFont(ofSize: 13.0)
  private static let kSkipButtonFont = UIFont.boldSystemFont(ofSize: 13.0)
  
  private var spotlightMask = CAShapeLayer()
  private var continueLabel = UILabel()
  private var skipSpotlightButton = UIButton()
  private var arrowDownImageView = UIImageView()
  private var arrowDownSize = CGSize(width: 12, height: 18)
  
  // MARK: - public variables
  
  var spotlightsArray = [AwesomeSpotlight]()
  var textLabel = UILabel()
  var spotlightMaskColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
  var animationDuration = kAnimationDuration
  var cutoutRadius : CGFloat = kCutoutRadius
  var maxLabelWidth = kMaxLabelWidth
  var labelSpacing : CGFloat = kMaxLabelSpacing
  var enableContinueLabel = kEnableContinueLabel
  var enableSkipButton = kEnableSkipButton
  var enableArrowDown = kEnableArrowDown
  var textLabelFont = kTextLabelFont
  var continueLabelFont = kContinueLabelFont
  var skipButtonFont = kSkipButtonFont
  var showAllSpotlightsAtOnce = kShowAllSpotlightsAtOnce
  
  var currentIndex = 0
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(frame: CGRect, spotlight: [AwesomeSpotlight]) {
    self.init(frame: frame)
    
    self.spotlightsArray = spotlight
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
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
    spotlightMask.fillRule = kCAFillRuleEvenOdd
    spotlightMask.fillColor = spotlightMaskColor.cgColor
    layer.addSublayer(spotlightMask)
  }
  
  private func setupTouches() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AwesomeSpotlightView.userDidTap(_:)))
    addGestureRecognizer(tapGestureRecognizer)
  }
  
  private func setupTextLabel() {
    textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: maxLabelWidth, height: 0))
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
    if let bundlePath = Bundle.main.path(forResource: "AwesomeSpotlightViewBundle", ofType: "bundle") {
      if let _ = Bundle(path: bundlePath)?.path(forResource: "arrowDownIcon", ofType: "png") {
        let arrowDownImage = UIImage(named: "arrowDownIcon", in: Bundle(path: bundlePath), compatibleWith: nil)
        arrowDownImageView = UIImageView(image: arrowDownImage)
        arrowDownImageView.alpha = 0
        addSubview(arrowDownImageView)
      }
    }
  }
  
  private func setupContinueLabel() {
    let continueLabelWidth = enableSkipButton ? 0.7 * bounds.size.width : bounds.size.width
    let continueLabelHeight : CGFloat = 30.0
    continueLabel = UILabel(frame: CGRect(x: 0, y: bounds.size.height - continueLabelHeight, width: continueLabelWidth, height: continueLabelHeight))
    continueLabel.font = continueLabelFont
    continueLabel.textAlignment = .center
    continueLabel.text = "Continue".localized
    continueLabel.alpha = 0
    continueLabel.backgroundColor = .white
    addSubview(continueLabel)
  }
  
  private func setupSkipSpotlightButton() {
    let continueLabelWidth = 0.7 * bounds.size.width
    let skipSpotlightButtonWidth = bounds.size.width - continueLabelWidth
    let skipSpotlightButtonHeight : CGFloat = 30.0
    skipSpotlightButton = UIButton(frame: CGRect(x: continueLabelWidth, y: bounds.size.height - skipSpotlightButtonHeight, width: skipSpotlightButtonWidth, height: skipSpotlightButtonHeight))
    skipSpotlightButton.addTarget(self, action: #selector(AwesomeSpotlightView.skipSpotlight), for: .touchUpInside)
    skipSpotlightButton.setTitle("Skip".localized, for: [])
    skipSpotlightButton.titleLabel?.font = skipButtonFont
    skipSpotlightButton.alpha = 0
    skipSpotlightButton.tintColor = .white
    addSubview(skipSpotlightButton)
  }
  
  // MARK: - Touches

  func userDidTap(_ recognizer: UITapGestureRecognizer) {
    goToSpotlightAtIndex(index: currentIndex + 1)
  }
  
  // MARK: - Presenter

  func start() {
    alpha = 0
    isHidden = false
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
    if index >= self.spotlightsArray.count {
      cleanup()
    } else if showAllSpotlightsAtOnce {
      showSpotlightsAllAtOnce()
    } else {
      showSpotlightAtIndex(index: index)
    }
  }
  
  private func showSpotlightsAllAtOnce() {
    if let firstSpotlight = spotlightsArray.first {
      enableContinueLabel = false
      enableSkipButton = false
      setCutoutToSpotlight(spotlight: firstSpotlight)
      animateCutoutToSpotlights(spotlights: spotlightsArray)
      currentIndex = spotlightsArray.count
    }
  }
  
  private func showSpotlightAtIndex(index: Int) {
    currentIndex = index
    
    let currentSpotlight = spotlightsArray[index]
    
    delegate?.spotlightView?(spotlightView: self, willNavigateToIndex: index)
    
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
    if enableContinueLabel {
      if index == 0 {
        setupContinueLabel()
        UIView.animate(withDuration: animationDuration, delay: 0.35, options: .curveLinear, animations: {
          self.continueLabel.alpha = 1
          }, completion: nil)
      } else if index >= spotlightsArray.count - 1 && continueLabel.alpha != 0 {
        continueLabel.alpha = 0
        continueLabel.removeFromSuperview()
      }
    }
  }
  
  private func showSkipButtonIfNeeded(index: Int) {
    if enableSkipButton && index == 0 {
      setupSkipSpotlightButton()
      UIView.animate(withDuration: animationDuration, delay: 0.35, options: .curveLinear, animations: {
        self.skipSpotlightButton.alpha = 1
        }, completion: nil)
    }
  }
  
  func skipSpotlight() {
    goToSpotlightAtIndex(index: spotlightsArray.count)
  }
  
  private func skipAllSpotlights() {
    goToSpotlightAtIndex(index: spotlightsArray.count)
  }
  
  // MARK: Helper
  
  private func calculateTextPositionAndSizeWithSpotlight(spotlight: AwesomeSpotlight) {
    textLabel.frame = CGRect(x: 0, y: 0, width: maxLabelWidth, height: 0)
    textLabel.attributedText = spotlight.showedText
    
    if enableArrowDown && currentIndex == 0 {
      labelSpacing += 18
    }
    
    textLabel.sizeToFit()
    
    let rect = spotlight.rect
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
    var rect = spotlight.rect
    
    if isFirst {
      let x = floor(spotlight.rect.origin.x + (spotlight.rect.size.width / 2.0))
      let y = floor(spotlight.rect.origin.y + (spotlight.rect.size.height / 2.0))
      
      let center = CGPoint(x: x, y: y)
      rect = CGRect(origin: center, size: CGSize.zero)
    }
    
    let spotlightPath = UIBezierPath(rect: bounds)
    var cutoutPath = UIBezierPath()
    
    switch spotlight.shape {
    case .Rectangle:
      cutoutPath = UIBezierPath(rect: rect)
    case .RoundRectangle:
      cutoutPath = UIBezierPath(roundedRect: rect, cornerRadius: cutoutRadius)
    case .Circle:
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
      case .Rectangle:
        cutoutPath = UIBezierPath(rect: spotlight.rect)
      case .RoundRectangle:
        cutoutPath = UIBezierPath(roundedRect: spotlight.rect, cornerRadius: cutoutRadius)
      case .Circle:
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
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.duration = animationDuration
    animation.isRemovedOnCompletion = false
    animation.fillMode = kCAFillModeForwards
    animation.fromValue = spotlightMask.path
    animation.toValue = path
    spotlightMask.add(animation, forKey: animationKeyPath)
    spotlightMask.path = path
  }
  
  // MARK: - Cleanup
  
  private func cleanup() {
    delegate?.spotlightViewWillCleanup?(spotlightView: self)
    UIView.animate(withDuration: animationDuration, animations: {
      self.alpha = 0
      }) { (finished) in
        self.removeFromSuperview()
        self.currentIndex = 0
        self.textLabel.alpha = 0
        self.continueLabel.alpha = 0
        self.skipSpotlightButton.alpha = 0
        self.delegate?.spotlightViewDidCleanup?(spotlightView: self)
    }
  }
  
}

extension AwesomeSpotlightView : CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    delegate?.spotlightView?(spotlightView: self, didNavigateToIndex: currentIndex)
  }
}
