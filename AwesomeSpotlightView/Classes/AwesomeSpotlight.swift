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
  private var text : String = ""
  private var attributedText : AttributedString? = nil
  
  var showedText: AttributedString {
    if let attrText = attributedText {
      return attrText
    } else {
      return AttributedString(string: text)
    }
  }
  
  var rectValue : NSValue {
    return NSValue(cgRect: rect)
  }
  
  init(withRect rect: CGRect, shape: AwesomeSpotlightShape, text: String) {
    super.init()
    self.rect = rect
    self.shape = shape
    self.text = text
  }
  
  init(withRect rect: CGRect, shape: AwesomeSpotlightShape, attributedText: AttributedString) {
    super.init()
    self.rect = rect
    self.shape = shape
    self.attributedText = attributedText
  }
  
  convenience override init() {
    self.init(withRect: CGRect(), shape: .RoundRectangle, text: "test")
  }
  
  
}
