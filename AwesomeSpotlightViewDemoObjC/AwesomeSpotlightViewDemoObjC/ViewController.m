//
//  ViewController.m
//  AwesomeSpotlightViewDemoObjC
//
//  Created by FromF on 2018/08/15.
//  Copyright © 2018年 FromF. All rights reserved.
//

#import "ViewController.h"
#import "AwesomeSpotlightViewDemoObjC-Swift.h"

@interface ViewController () <AwesomeSpotlightViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIButton *showWithContinueAndSkipButton;
@property (weak, nonatomic) IBOutlet UIButton *showAllAtOnceButton;

@property (strong, nonatomic) AwesomeSpotlightView *spotlightView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupSpotlight];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupViews {
    self.showButton.layer.cornerRadius = 8.0;
    self.showButton.clipsToBounds = true;
    
    self.showWithContinueAndSkipButton.layer.cornerRadius = 8.0;
    self.showWithContinueAndSkipButton.clipsToBounds = true;
    
    self.showAllAtOnceButton.layer.cornerRadius = 8.0;
    self.showAllAtOnceButton.clipsToBounds = true;
}

- (void)setupSpotlight {
    UIEdgeInsets spotlightMarginDefault = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    CGRect logoImageViewSpotlightRect = CGRectMake(self.logoImageView.frame.origin.x, self.logoImageView.frame.origin.y, self.logoImageView.frame.size.width, self.logoImageView.frame.size.height);
    UIEdgeInsets logoImageViewSpotlightMargin = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
    AwesomeSpotlight *logoImageViewSpotlight = [[AwesomeSpotlight alloc] initWithRect:logoImageViewSpotlightRect shape:AwesomeSpotlightShapeCircle text:@"logoImageViewSpotlight" margin:logoImageViewSpotlightMargin isAllowPassTouchesThroughSpotlight:false];
    
    AwesomeSpotlight *nameLabelSpotlight = [[AwesomeSpotlight alloc] initWithRect:self.nameLabel.frame shape:AwesomeSpotlightShapeRectangle text:@"nameLabelSpotlight" margin:spotlightMarginDefault isAllowPassTouchesThroughSpotlight:false];
    
    AwesomeSpotlight *showButtonSpotSpotlight = [[AwesomeSpotlight alloc] initWithRect:self.showButton.frame shape:AwesomeSpotlightShapeRoundRectangle text:@"showButtonSpotSpotlight" margin:spotlightMarginDefault isAllowPassTouchesThroughSpotlight:false];

    AwesomeSpotlight *showWithContinueAndSkipButtonSpotlight = [[AwesomeSpotlight alloc] initWithRect:self.showWithContinueAndSkipButton.frame shape:AwesomeSpotlightShapeRoundRectangle text:@"showWithContinueAndSkipButtonSpotlight" margin:spotlightMarginDefault isAllowPassTouchesThroughSpotlight:false];
    
    AwesomeSpotlight *showAllAtOnceButtonSpotlight = [[AwesomeSpotlight alloc] initWithRect:self.showAllAtOnceButton.frame shape:AwesomeSpotlightShapeRoundRectangle text:@"showAllAtOnceButtonSpotlight" margin:spotlightMarginDefault isAllowPassTouchesThroughSpotlight:false];
    
    self.spotlightView = [[AwesomeSpotlightView alloc] initWithFrame:self.view.frame spotlight:@[logoImageViewSpotlight, nameLabelSpotlight, showButtonSpotSpotlight, showWithContinueAndSkipButtonSpotlight, showAllAtOnceButtonSpotlight]];
    self.spotlightView.cutoutRadius = 8;
    self.spotlightView.delegate = self;
}

#pragma mark Actions
- (IBAction)handleShowAction:(id)sender {
    [self.view addSubview:self.spotlightView];
    [self.spotlightView setContinueButtonEnable:false];
    [self.spotlightView setSkipButtonEnable:false];
    self.spotlightView.showAllSpotlightsAtOnce = false;
    [self.spotlightView start];
}

- (IBAction)handleShowWithContinueAndSkipAction:(id)sender {
    [self.view addSubview:self.spotlightView];
    [self.spotlightView setContinueButtonEnable:true];
    [self.spotlightView setSkipButtonEnable:true];
    self.spotlightView.showAllSpotlightsAtOnce = false;
    [self.spotlightView start];
}

- (IBAction)handleShowAllAtOnceAction:(id)sender {
    [self.view addSubview:self.spotlightView];
    [self.spotlightView setContinueButtonEnable:false];
    [self.spotlightView setSkipButtonEnable:false];
    self.spotlightView.showAllSpotlightsAtOnce = true;
    [self.spotlightView start];
}

#pragma mark AwesomeSpotlightViewDelegate
- (void)spotlightView:(AwesomeSpotlightView *)spotlightView willNavigateToIndex:(NSInteger)index {
    NSLog(@"spotlightView willNavigateToIndex index =  %ld",(long)index);
}

- (void)spotlightView:(AwesomeSpotlightView *)spotlightView didNavigateToIndex:(NSInteger)index {
    NSLog(@"spotlightView didNavigateToIndex index =  %ld",(long)index);
}

- (void)spotlightViewWillCleanup:(AwesomeSpotlightView *)spotlightView atIndex:(NSInteger)index {
    NSLog(@"spotlightViewWillCleanup atIndex =  %ld",(long)index);
}

- (void)spotlightViewDidCleanup:(AwesomeSpotlightView *)spotlightView {
    NSLog(@"spotlightViewDidCleanup");
}

@end
