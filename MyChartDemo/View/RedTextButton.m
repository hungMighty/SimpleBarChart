//
//  RedTextButton.m
//  MyChartDemo
//
//  Created by Ahri on 7/20/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "RedTextButton.h"
#import "UIColor+RGB.h"

@interface RedTextButton () {
}

@end

@implementation RedTextButton

// load from nib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupButton];
    }
    return self;
}

// custom init with frame
- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
        [self setupButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setupButton {
    [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    if (self.touchupColor == nil) {
        self.touchupColor = [UIColor rgb:165 green:0 blue:0];
    }
    if (self.normalColor == nil) {
        self.normalColor = [UIColor rgb:165 green:165 blue:165];
    }
    [self setTitleColor:self.normalColor forState:UIControlStateNormal];
}

- (void)didTouchButton {
    [self setTitleColor:self.touchupColor forState:UIControlStateNormal];
    for (int i = 0; i < self.buttonsGroup.count; i++) {
        if (self != self.buttonsGroup[i]) {
            [self.buttonsGroup[i] setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
    }
}


@end
