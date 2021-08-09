//
//  ViewController.swift
//  AwesomeSpotlightView
//
//  Created by Alex Shoshiashvili on 24.02.17.
//  Copyright © 2017 Alex Shoshiashvili. All rights reserved.
//

import UIKit
import AwesomeSpotlightView

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
    
    let showAllAtOnceButtonSpotlight = AwesomeSpotlight(withRect: showAllAtOnceButton.frame, shape: .roundRectangle, text: "showAllAtOnceButtonSpotlight", isAllowPassTouchesThroughSpotlight: true)
    
    spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [logoImageViewSpotlight, nameLabelSpotlight, showButtonSpotSpotlight, showWithContinueAndSkipButtonSpotlight, showAllAtOnceButtonSpotlight])
    spotlightView.cutoutRadius = 8
    spotlightView.delegate = self
  }
  
  // MARK: - Actions
  
  @IBAction func handleShowAction(_ sender: AnyObject) {
    view.addSubview(spotlightView)
    spotlightView.continueButtonModel.isEnable = false
    spotlightView.skipButtonModel.isEnable = false
    spotlightView.showAllSpotlightsAtOnce = false
    spotlightView.start()
  }
  @IBAction func handleShowWithContinueAndSkipAction(_ sender: AnyObject) {
    view.addSubview(spotlightView)
    spotlightView.continueButtonModel.isEnable = true
    spotlightView.skipButtonModel.isEnable = true
    spotlightView.showAllSpotlightsAtOnce = false
    
    // Uncomment if want to customize skip button
    //spotlightView.skipButtonLastStepTitle = "Finish"
    //spotlightView.skipButtonModel = AwesomeTabButton(title: "Skip".uppercased(),
    //                                                 font: UIFont.boldSystemFont(ofSize: 16.0),
    //                                                 isEnable: true,
    //                                                 backgroundColor: .red)
    
    // Uncomment if want to customize continue button
    //spotlightView.continueButtonModel = AwesomeTabButton(title: "Next",
    //                                                     font: UIFont.italicSystemFont(ofSize: 16.0),
    //                                                     isEnable: true,
    //                                                     backgroundColor: .blue)
    
    spotlightView.start()
  }
  @IBAction func handleShowAllAtOnceAction(_ sender: AnyObject) {
    view.addSubview(spotlightView)
    spotlightView.continueButtonModel.isEnable = false
    spotlightView.skipButtonModel.isEnable = false
    spotlightView.showAllSpotlightsAtOnce = true
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
