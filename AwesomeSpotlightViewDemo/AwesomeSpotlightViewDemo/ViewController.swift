//
//  ViewController.swift
//  AwesomeSpotlightView
//
//  Created by Alex Shoshiashvili on 24.02.17.
//  Copyright © 2017 Alex Shoshiashvili. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var showButton: UIButton!
  @IBOutlet weak var showWithContinueAndSkipButton: UIButton!
  @IBOutlet weak var showAllAtOnceButton: UIButton!
  
  var spotlightView = AwesomeSpotlightView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupSpotlight()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setupViews() {
    showButton.layer.cornerRadius = 8.0
    showButton.clipsToBounds = true
    
    showWithContinueAndSkipButton.layer.cornerRadius = 8.0
    showWithContinueAndSkipButton.clipsToBounds = true
    
    showAllAtOnceButton.layer.cornerRadius = 8.0
    showAllAtOnceButton.clipsToBounds = true
  }
  
  func setupSpotlight() {
    let logoImageViewSpotlightRect = CGRect(x: logoImageView.frame.origin.x, y: logoImageView.frame.origin.y, width: logoImageView.frame.size.width, height: logoImageView.frame.size.height)
    let logoImageViewSpotlightMargin = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    let logoImageViewSpotlight = AwesomeSpotlight(withRect: logoImageViewSpotlightRect, shape: .circle, text: "logoImageViewSpotlight", margin: logoImageViewSpotlightMargin)
    
    let nameLabelSpotlight = AwesomeSpotlight(withRect: nameLabel.frame, shape: .rectangle, text: "nameLabelSpotlight")
    
    let showButtonSpotSpotlight = AwesomeSpotlight(withRect: showButton.frame, shape: .roundRectangle, text: "showButtonSpotSpotlight")
    
    let showWithContinueAndSkipButtonSpotlight = AwesomeSpotlight(withRect: showWithContinueAndSkipButton.frame, shape: .roundRectangle, text: "showWithContinueAndSkipButtonSpotlight")
    
    let showAllAtOnceButtonSpotlight = AwesomeSpotlight(withRect: showAllAtOnceButton.frame, shape: .roundRectangle, text: "showAllAtOnceButtonSpotlight")
    
    spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [logoImageViewSpotlight, nameLabelSpotlight, showButtonSpotSpotlight, showWithContinueAndSkipButtonSpotlight, showAllAtOnceButtonSpotlight])
    spotlightView.cutoutRadius = 8
    spotlightView.delegate = self
  }
  
  // MARK: - Actions
  
  @IBAction func handleShowAction(_ sender: AnyObject) {
    view.addSubview(spotlightView)
    spotlightView.enableContinueLabel = false
    spotlightView.enableSkipButton = false
    spotlightView.showAllSpotlightsAtOnce = false
    spotlightView.isAllowPassTouchesThroughSpotlight = true
    spotlightView.start()
  }
  @IBAction func handleShowWithContinueAndSkipAction(_ sender: AnyObject) {
    view.addSubview(spotlightView)
    spotlightView.enableContinueLabel = true
    spotlightView.enableSkipButton = true
    spotlightView.showAllSpotlightsAtOnce = false
    spotlightView.isAllowPassTouchesThroughSpotlight = false
    spotlightView.start()
  }
  @IBAction func handleShowAllAtOnceAction(_ sender: AnyObject) {
    view.addSubview(spotlightView)
    spotlightView.enableContinueLabel = false
    spotlightView.enableSkipButton = false
    spotlightView.showAllSpotlightsAtOnce = true
    spotlightView.isAllowPassTouchesThroughSpotlight = false
    spotlightView.start()
  }
  
}

extension ViewController : AwesomeSpotlightViewDelegate {
  
  func spotlightView(_ spotlightView: AwesomeSpotlightView, willNavigateToIndex index: Int) {
    print("spotlightView willNavigateToIndex index = \(index)")
  }
  
  func spotlightView(_ spotlightView: AwesomeSpotlightView, didNavigateToIndex index: Int) {
    print("spotlightView didNavigateToIndex index = \(index)")
  }
  
  func spotlightViewWillCleanup(_ spotlightView: AwesomeSpotlightView, atIndex index: Int) {
    print("spotlightViewWillCleanup atIndex = \(index)")
  }
  
  func spotlightViewDidCleanup(_ spotlightView: AwesomeSpotlightView) {
    print("spotlightViewDidCleanup")
  }
  
}
