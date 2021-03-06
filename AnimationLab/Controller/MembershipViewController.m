//
//  MembershipViewController.m
//  MyChartDemo
//
//  Created by Ahri on 7/12/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "MembershipViewController.h"
#import "UtilityClasses.h"
#import "SimpleHorizontalBarChart.h"
#import "BarChartValueLabel.h"
#import "CustomRankingPanel.h"
#import "CircleLabel.h"
#import "RightRoundCornerLabel.h"
#import "GroupButtonWithColor.h"
#import "WaveView.h"

@interface MembershipViewController () {
    NSMutableArray<SimpleHorizontalBarChart *> *chartBackViews;
    NSMutableArray<BarChartValueLabel *> *valueLabels;
    NSMutableArray<UIView *> *rankingPanels;
    int ovalPanelRadius;
    UIColor *bronzePanelColor;
    UIColor *silverPanelColor;
    UIColor *goldPanelColor;
    CGFloat waveHeight;
    BOOL viewAlreadyLayout;
}

@property (weak, nonatomic) IBOutlet GroupButtonWithColor *membershipButton;
@property (weak, nonatomic) IBOutlet GroupButtonWithColor *topResultButton;
@property (weak, nonatomic) IBOutlet GroupButtonWithColor *currentRankButton;
@property (weak, nonatomic) IBOutlet UIView *animatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animatedLineLeftMargin;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *membershipSubview;
@property (weak, nonatomic) IBOutlet UIView *topResultsSubview;
@property (weak, nonatomic) IBOutlet UIView *curRankSubview;

@property (weak, nonatomic) IBOutlet UIView *membershipView;
@property (weak, nonatomic) IBOutlet RightRoundCornerLabel *membershipLabel;
@property (strong, nonatomic) UIView *waveViewContainer;
@property (strong, nonatomic) WaveView *waveView;
@property (strong, nonatomic) WaveView *shadowWaveView;

@property (weak, nonatomic) IBOutlet UIView *panelsContainerBackground;
@property (weak, nonatomic) IBOutlet UIView *panelsContainer;

@property (weak, nonatomic) IBOutlet CustomRankingPanel *bronzePanelOval;
@property (weak, nonatomic) IBOutlet CustomRankingPanel *silverPanelOval;
@property (weak, nonatomic) IBOutlet CustomRankingPanel *goldPanelOval;

@property (weak, nonatomic) IBOutlet UIView *bronzePanel;
@property (weak, nonatomic) IBOutlet UIView *silverPanel;
@property (weak, nonatomic) IBOutlet UIView *goldPanel;

@property (weak, nonatomic) IBOutlet UILabel *bronzeLevelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverLevelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLevelTitleLabel;

@property (weak, nonatomic) IBOutlet BarChartValueLabel *bronzeValueLabel;
@property (weak, nonatomic) IBOutlet BarChartValueLabel *silverValueLabel;
@property (weak, nonatomic) IBOutlet BarChartValueLabel *goldValueLabel;

@property (weak, nonatomic) IBOutlet SimpleHorizontalBarChart *bronzeBarChart;
@property (weak, nonatomic) IBOutlet SimpleHorizontalBarChart *silverBarChart;

@property (weak, nonatomic) IBOutlet CircleLabel *targetBronzeLabel;
@property (weak, nonatomic) IBOutlet CircleLabel *targetSilverLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cupIconWidth;

@end

@implementation MembershipViewController

- (void)emulateData {
    self.bronzeBarChartValues = [[NSMutableArray alloc] init];
    self.silverBarChartValues = [[NSMutableArray alloc] init];
    self.goldBarChartValues = [[NSMutableArray alloc] init];
    [self.bronzeBarChartValues addObject:@4];
    [self.bronzeBarChartValues addObject:@7];
    [self.silverBarChartValues addObject:@3];
    [self.silverBarChartValues addObject:@4];
    [self.goldBarChartValues addObject:@0];
}

#pragma mark - View Auto-Rotation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma View LifeCycles

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self putViewsIntoArrays];
    [self emulateData];
    [self mapDataToViews];
    
    ovalPanelRadius = 8;
    bronzePanelColor = [UIColor rgb:166 green:124 blue:0];
    silverPanelColor = [UIColor rgb:146 green:156 blue:157];
    goldPanelColor = [UIColor rgb:255 green:223 blue:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setColorForMultipleViews];
    [self.membershipButton didTouchButton];
    int screenHeight = (int) [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight >= 667) {
        self.cupIconWidth.constant = 45; // bigger cup icon size for iPhone S
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self addRightCornerToRankingPanels];
    if (!viewAlreadyLayout) {
        [self animateWaveView];
        viewAlreadyLayout = true;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)putViewsIntoArrays {
    chartBackViews = [[NSMutableArray alloc] init];
    [chartBackViews addObject:self.bronzeBarChart];
    [chartBackViews addObject:self.silverBarChart];
    valueLabels = [[NSMutableArray alloc] init];
    [valueLabels addObject:self.bronzeValueLabel];
    [valueLabels addObject:self.silverValueLabel];
    [valueLabels addObject:self.goldValueLabel];
    rankingPanels = [[NSMutableArray alloc] init];
    [rankingPanels addObject:self.bronzePanel];
    [rankingPanels addObject:self.silverPanel];
    [rankingPanels addObject:self.goldPanel];
    NSMutableArray<GroupButtonWithColor *> *topButtonsGroup = [[NSMutableArray alloc]
                                                        initWithObjects:self.membershipButton,
                                                        self.topResultButton,
                                                        self.currentRankButton, nil];
    self.membershipButton.buttonsGroup = topButtonsGroup;
    self.topResultButton.buttonsGroup = topButtonsGroup;
    self.currentRankButton.buttonsGroup = topButtonsGroup;
}

- (void)mapDataToViews {
    self.membershipLabel.labelTitle = @"Membership";
    self.bronzeBarChart.ratio = @([self.bronzeBarChartValues[0] floatValue] / [self.bronzeBarChartValues[1] floatValue]);
    self.silverBarChart.ratio = @([self.silverBarChartValues[0] floatValue] / [self.silverBarChartValues[1] floatValue]);
    self.bronzeValueLabel.barChartValues = self.bronzeBarChartValues;
    self.silverValueLabel.barChartValues = self.silverBarChartValues;
    self.goldValueLabel.barChartValues = self.goldBarChartValues;
    
    NSString *remainBronze = @"";
    NSString *remainSilver = @"";
    remainBronze = [NSString stringWithFormat:@"%i", (int)[self.bronzeBarChartValues[1] floatValue] - (int)[self.bronzeBarChartValues[0] floatValue]];
    remainSilver = [NSString stringWithFormat:@"%i", (int)[self.silverBarChartValues[1] floatValue] - (int)[self.silverBarChartValues[0] floatValue]];
    self.targetBronzeLabel.text = remainBronze;
    self.targetSilverLabel.text = remainSilver;
}

- (void)setColorForMultipleViews {
    self.membershipView.backgroundColor = UIColor.whiteColor;
    self.panelsContainerBackground.backgroundColor = UIColor.whiteColor;
    self.panelsContainer.backgroundColor = UIColor.whiteColor;
    
    self.bronzePanelOval.backgroundColor = bronzePanelColor;
    self.silverPanelOval.backgroundColor = silverPanelColor;
    self.goldPanelOval.backgroundColor = goldPanelColor;
    self.bronzeLevelTitleLabel.textColor = bronzePanelColor;
    self.silverLevelTitleLabel.textColor = silverPanelColor;
    self.goldLevelTitleLabel.textColor = goldPanelColor;
}

- (void)addRightCornerToRankingPanels {
    for (int i = 0; i < rankingPanels.count; i++) {
        UIView *panel = rankingPanels[i];
        UIBezierPath *path =  [UIBezierPath bezierPathWithRoundedRect:panel.bounds
                                                    byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(ovalPanelRadius, ovalPanelRadius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = panel.bounds;
        [maskLayer setPath:path.CGPath];
        panel.layer.mask = maskLayer;
    }
}

- (void)animateWaveView {
    UIColor *redColor = [UIColor rgb:204 green:0 blue:0];
    UIColor *shadowRedColor = [UIColor rgb:255 green:153 blue:153];
    waveHeight = 9;
    CGFloat waveTimeOfFrontWave = 1;
    
    CGRect waveContainerFrame = self.membershipView.frame;
    waveContainerFrame.size.height = 0;
    waveContainerFrame.origin.y = self.membershipView.frame.size.height - waveContainerFrame.size.height;
    if (self.waveViewContainer != nil) {
        [self.waveViewContainer removeFromSuperview];
        self.waveView = nil;
        self.shadowWaveView = nil;
    }
    self.waveViewContainer = [[UIView alloc] initWithFrame:waveContainerFrame];
    self.waveViewContainer.clipsToBounds = false;
    self.waveViewContainer.backgroundColor = redColor;
    [self.membershipView insertSubview:self.waveViewContainer belowSubview:self.membershipLabel];
    
    // Add new Shadow WaveView
    self.shadowWaveView = [WaveView addToView:self.waveViewContainer
                              withFrame:CGRectMake(0, -(waveHeight - 0.2),
                                                   self.waveViewContainer.frame.size.width, waveHeight)];
    self.shadowWaveView.waveColor = shadowRedColor;
    self.shadowWaveView.angularSpeed = 2.5f;
    self.shadowWaveView.steepIncrementUnit = 0.18f;
    self.shadowWaveView.waveTime = waveTimeOfFrontWave; // make wave view animate indefinitely with input -1
    
    // Add new waveView
    self.waveView = [WaveView addToView:self.waveViewContainer
                              withFrame:CGRectMake(0, -(waveHeight - 0.2),
                                                   self.waveViewContainer.frame.size.width, waveHeight)];
    self.waveView.waveColor = [redColor colorWithAlphaComponent:0.5];
    self.waveView.isFrontWave = true;
    [self.waveView setOpaque:false];
    self.waveView.angularSpeed = 2.5f;
    self.waveView.steepIncrementUnit = 0.2f;
    self.waveView.waveTime = waveTimeOfFrontWave; // make wave view animate indefinitely with input -1
    
    // Start Animating waves
    [self.waveView wave];
    [self.shadowWaveView wave];
    
    // Animate waveViewContainer to go up from bottom
//    waveContainerFrame.size.height = 0;
//    waveContainerFrame.origin.y = self.membershipView.frame.size.height - waveContainerFrame.size.height;
//    [UIView animateWithDuration:2.5f animations:^{
//        [self.waveViewContainer setFrame:waveContainerFrame];
//    } completion:^(BOOL finished) {
//        CGRect waveViewFrame = self.waveView.frame;
//        waveViewFrame.origin.y = -(waveHeight - 0.05);
//        self.waveView.frame = waveViewFrame;
//    }];
}

#pragma Actions

- (IBAction)membershipClicked:(id)sender {
    [self.view bringSubviewToFront:self.membershipSubview];
}

- (IBAction)topResultsClicked:(id)sender {
    self.topResultsSubview.backgroundColor = UIColor.greenColor;
    [self.view bringSubviewToFront:self.topResultsSubview];
}

// MARK: - Utility Functions
- (void)animateLine:(CGFloat)x {
    self.animatedLineLeftMargin.constant = x;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.animatedLine layoutIfNeeded];
        [self.view layoutIfNeeded];
    } completion:nil];
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    [self animateLine:offsetX / 3];
    if (offsetX == self.membershipButton.frame.origin.x) {
        [self.membershipButton didTouchButton];
    }
    if (offsetX == self.topResultButton.frame.origin.x) {
        [self.topResultButton didTouchButton];
    }
    if (offsetX == self.currentRankButton.frame.origin.x) {
        [self.currentRankButton didTouchButton];
    }
}

@end
