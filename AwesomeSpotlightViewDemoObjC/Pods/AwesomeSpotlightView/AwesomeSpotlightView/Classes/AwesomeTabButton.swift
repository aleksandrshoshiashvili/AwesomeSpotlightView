//
//  AwesomeTabButton.swift
//  AwesomeSpotlightViewDemo
//
//  Created by Alexander Shoshiashvili on 11/02/2018.
//  Copyright © 2018 Alex Shoshiashvili. All rights reserved.
//

import UIKit

public struct AwesomeTabButton {
  
  public var title: String
  public var font: UIFont
  public var isEnable: Bool
  public var backgroundColor: UIColor?
  
  public init(title: String, font: UIFont, isEnable: Bool = true, backgroundColor: UIColor? = nil) {
    self.title = title
    self.font = font
    self.isEnable = isEnable
    self.backgroundColor = backgroundColor
  }
  
}
