//
//  AwesomeSpotlight.swift
//  AwesomeSpotlightView
//
//  Created by Alex Shoshiashvili on 24.02.17.
//  Copyright © 2017 Alex Shoshiashvili. All rights reserved.
//

import UIKit

class AwesomeSpotlight: NSObject {
  
  enum AwesomeSpotlightShape {
    case Rectangle
    case RoundRectangle
    case Circle
  }
  
  var rect = CGRect()
  var shape : AwesomeSpotlightShape = .RoundRectangle
  var margin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  private var text : String = ""
  private var attributedText : NSAttributedString? = nil
  private let zeroMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  
  var showedText: NSAttributedString {
    if let attrText = attributedText {
      return attrText
    } else {
      return NSAttributedString(string: text)
    }
  }
  
  var rectValue : NSValue {
    return NSValue(cgRect: rect)
  }
  
  init(withRect rect: CGRect,
       shape: AwesomeSpotlightShape,
       text: String,
       margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
    super.init()
    self.rect = rect
    self.shape = shape
    self.text = text
    self.margin = margin
  }
  
  init(withRect rect: CGRect,
       shape: AwesomeSpotlightShape,
       attributedText: NSAttributedString,
       margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
    super.init()
    self.rect = rect
    self.shape = shape
    self.attributedText = attributedText
    self.margin = margin
  }
  
  convenience override init() {
    self.init(withRect: CGRect(), shape: .RoundRectangle, text: "test", margin: UIEdgeInsets())
  }
  
  
}
