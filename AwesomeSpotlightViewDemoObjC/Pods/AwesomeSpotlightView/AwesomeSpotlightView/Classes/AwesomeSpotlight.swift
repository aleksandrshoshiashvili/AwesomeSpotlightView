//
//  AwesomeSpotlight.swift
//  AwesomeSpotlightView
//
//  Created by Alex Shoshiashvili on 24.02.17.
//  Copyright © 2017 Alex Shoshiashvili. All rights reserved.
//

import UIKit

open class AwesomeSpotlight: NSObject {
    
    @objc public enum AwesomeSpotlightShape : Int {
        case rectangle
        case roundRectangle
        case circle
    }
    
    var rect = CGRect()
    var shape: AwesomeSpotlightShape = .roundRectangle
    var margin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var isAllowPassTouchesThroughSpotlight = false
    
    private var text: String = ""
    private var attributedText: NSAttributedString? = nil
    private let zeroMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    var showedText: NSAttributedString {
        if let attrText = attributedText {
            return attrText
        } else {
            return NSAttributedString(string: text)
        }
    }
    
    var rectValue: NSValue {
        return NSValue(cgRect: rect)
    }
    
    @objc public init(withRect rect: CGRect,
                      shape: AwesomeSpotlightShape,
                      text: String,
                      margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                      isAllowPassTouchesThroughSpotlight: Bool = false) {
        super.init()
        self.rect = rect
        self.shape = shape
        self.text = text
        self.margin = margin
        self.isAllowPassTouchesThroughSpotlight = isAllowPassTouchesThroughSpotlight
    }
    
    @objc public init(withRect rect: CGRect,
                      shape: AwesomeSpotlightShape,
                      attributedText: NSAttributedString,
                      margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                      isAllowPassTouchesThroughSpotlight: Bool = false) {
        super.init()
        self.rect = rect
        self.shape = shape
        self.attributedText = attributedText
        self.margin = margin
        self.isAllowPassTouchesThroughSpotlight = isAllowPassTouchesThroughSpotlight
    }
    
    convenience override public init() {
        self.init(withRect: CGRect(), shape: .roundRectangle, text: "", margin: UIEdgeInsets())
    }
    
}
