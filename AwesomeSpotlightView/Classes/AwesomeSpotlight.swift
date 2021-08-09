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
  var shape : AwesomeSpotlightShape = .roundRectangle
  var margin: UIEdgeInsets = .zero
  var isAllowPassTouchesThroughSpotlight = false
  
  private var text : String = ""
  private var attributedText : NSAttributedString? = nil
  private let zeroMargin: UIEdgeInsets = .zero
  
  var showedText: NSAttributedString {
    if let attrText = attributedText {
      return attrText
    } else {
      return .init(string: text)
    }
  }
  
  var rectValue : NSValue {
    return .init(cgRect: rect)
  }
  
  @objc public init(
    withRect rect: CGRect,
    shape: AwesomeSpotlightShape,
    text: String,
    margin: UIEdgeInsets = .zero,
    isAllowPassTouchesThroughSpotlight: Bool = false
  ) {
    super.init()
    self.rect = rect
    self.shape = shape
    self.text = text
    self.margin = margin
    self.isAllowPassTouchesThroughSpotlight = isAllowPassTouchesThroughSpotlight
  }
  
  @objc public init(
    withRect rect: CGRect,
    shape: AwesomeSpotlightShape,
    attributedText: NSAttributedString,
    margin: UIEdgeInsets = .zero,
    isAllowPassTouchesThroughSpotlight: Bool = false
  ) {
    super.init()
    self.rect = rect
    self.shape = shape
    self.attributedText = attributedText
    self.margin = margin
    self.isAllowPassTouchesThroughSpotlight = isAllowPassTouchesThroughSpotlight
  }
  
  convenience override public init() {
    self.init(withRect: .init(), shape: .roundRectangle, text: "", margin: .init())
  }
  
}
