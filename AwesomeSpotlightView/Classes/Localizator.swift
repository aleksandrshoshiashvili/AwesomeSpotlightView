//
//  Localizator.swift
//  AwesomeSpotlightView
//
//  Created by David Cordero 
//  Update by Alex Shoshiashvili
//  https://medium.com/@dcordero/a-different-way-to-deal-with-localized-strings-in-swift-3ea0da4cd143#.b863b9n1q

import Foundation

private class Localizator {

  static let sharedInstance = Localizator()

  private struct Constants {
    static let bundleResourceName = "AwesomeSpotlightViewBundle"
    static let bundleResourceType = "bundle"
    static let localisationResourceName = "Localizable"
    static let localisationResourceType = "plist"
    static let buttonLocalisationKey = "Buttons"
  }

  private init() {}
  
  lazy var localizableDictionary: NSDictionary! = {
    if let path = Bundle.module.path(
      forResource: Constants.localisationResourceName,
      ofType: Constants.localisationResourceType
    ) {
      return NSDictionary(contentsOfFile: path)
    } else if let bundlePath = Bundle(for: AwesomeSpotlightView.self).path(
      forResource: Constants.bundleResourceName,
      ofType: Constants.bundleResourceType
    ), let path = Bundle(path: bundlePath)?.path(
      forResource: Constants.localisationResourceName,
      ofType: Constants.localisationResourceType
    ) {
      return NSDictionary(contentsOfFile: path)
    }
    fatalError("Localizable file NOT found")
  }()
  
  func localize(string: String) -> String {
    guard let localizedString = ((localizableDictionary.value(forKey: Constants.buttonLocalisationKey) as AnyObject).value(forKey: string) as AnyObject).value(forKey: "value") as? String else {
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
