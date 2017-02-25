//
//  Localizator.swift
//  AwesomeSpotlightView
//
//  Created by David Cordero, Alex Shoshiashvili
//  https://medium.com/@dcordero/a-different-way-to-deal-with-localized-strings-in-swift-3ea0da4cd143#.b863b9n1q

import Foundation

private class Localizator {
  
  static let sharedInstance = Localizator()
  
  lazy var localizableDictionary: NSDictionary! = {
    
    //NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"AquarianHarp" ofType:@"bundle"];
    //NSString *imageName = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"trebleclef2" ofType:@"png"];
    
    //AweosmeSpotlightViewBundle
    
    if let bundlePath = Bundle.main().pathForResource("AwesomeSpotlightViewBundle", ofType: "bundle") {
      if let path = Bundle(path: bundlePath)?.pathForResource("Localizable", ofType: "plist") {
        return NSDictionary(contentsOfFile: path)
      }
    }
    fatalError("Localizable file NOT found")
  }()
  
  func localize(string: String) -> String {
    guard let localizedString = localizableDictionary.value(forKey: "Buttons")?.value(forKey: string)?.value(forKey: "value") as? String else {
      assertionFailure("Missing translation for: \(string)")
      return ""
    }
    return localizedString
  }
}

extension String {
  var localized: String {
    return Localizator.sharedInstance.localize(string: self)
  }
}
