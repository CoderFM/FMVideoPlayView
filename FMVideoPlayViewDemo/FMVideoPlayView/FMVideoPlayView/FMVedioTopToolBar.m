//
//  FMVedioTopToolBar.m
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/20.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "FMVedioTopToolBar.h"
#import "FMVedioNoHighlightButton.h"

@implementation FMVedioTopToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:FMVedioTopToolBarNormalMargin];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.exitButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0 constant:FMVedioTopToolBarExitButtonWidth];
        [self addConstraints:@[left, top, bottom]];
        [self.exitButton addConstraint:width];
    }
    return self;
}

- (FMVedioNoHighlightButton *)exitButton{
    if (_exitButton == nil) {
        FMVedioNoHighlightButton *btn = [FMVedioNoHighlightButton buttonWithType:UIButtonTypeCustom];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn setImage:[UIImage imageNamed:@"fmvideo_icon_exit"] forState:UIControlStateNormal];
        [self addSubview:btn];
        _exitButton = btn;
    }
    return _exitButton;
}

@end
