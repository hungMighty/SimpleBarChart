//
//  CustomRankingPanel.m
//  MyChartDemo
//
//  Created by Ahri on 7/17/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "CustomRankingPanel.h"

@interface CustomRankingPanel () {
}

@end

@implementation CustomRankingPanel

// load from nib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultStatistics];
        [self customizeBarchartBackground];
    }
    return self;
}

// custom init with frame
- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
        [self initDefaultStatistics];
        [self customizeBarchartBackground];
    }
    return self;
}

- (void)initDefaultStatistics {
    if (self.cornerRadius == nil) {
        self.cornerRadius = @6;
    }
}

- (void)customizeBarchartBackground {
    self.layer.cornerRadius = [self.cornerRadius floatValue];
    self.backgroundColor = UIColor.whiteColor;
    
    // Add Border to bar chart
    //    self.layer.borderColor = [UIColor rgb:240 green:240 blue:240].CGColor;
    //    self.layer.borderWidth = 1.0f;
    
    // Add Shadow to bar chart
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    self.layer.shadowRadius = 2.5f;
}

@end
