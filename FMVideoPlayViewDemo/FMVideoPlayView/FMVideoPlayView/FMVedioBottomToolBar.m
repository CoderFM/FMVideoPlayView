//
//  FMVedioBottomToolBar.m
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "FMVedioBottomToolBar.h"

@implementation FMVedioNoHighlightButton

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end

@implementation FMVedioBottomToolBar

- (void)setCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime{
    self.currentTimeLabel.text = currentTime;
    self.totalTimeLabel.text = [NSString stringWithFormat:@"/%@", totalTime];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 自动布局
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 全面按钮
        self.fullScreenButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.fullScreenButton addConstraint:[NSLayoutConstraint constraintWithItem:self.fullScreenButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:FMVedioBottomToolBarHeight]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fullScreenButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fullScreenButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.fullScreenButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-FMVedioBottomToolBarNormalMargin]];
        
        // 播放按钮
        self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.playButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:FMVedioBottomToolBarNormalMargin]];
        
        // 当前时间
        self.currentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.playButton attribute:NSLayoutAttributeRight multiplier:1 constant:FMVedioBottomToolBarNormalMargin]];
        
        // 总时间
        self.totalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.totalTimeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.currentTimeLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        // 时间滚动条
        self.slider.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.totalTimeLabel attribute:NSLayoutAttributeRight multiplier:1 constant:FMVedioBottomToolBarNormalMargin]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.slider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.fullScreenButton attribute:NSLayoutAttributeLeft multiplier:1 constant:-FMVedioBottomToolBarNormalMargin]];
    }
    return self;
}

- (FMVedioNoHighlightButton *)fullScreenButton{
    if (_fullScreenButton == nil) {
        FMVedioNoHighlightButton *btn = [[FMVedioNoHighlightButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"fmvideo_icon_ fullscreen"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"fmvideo_icon_ fullscreen_no"] forState:UIControlStateSelected];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:btn];
        _fullScreenButton = btn;
    }
    return _fullScreenButton;
}

- (FMVedioNoHighlightButton *)playButton{
    if (nil == _playButton) {
        FMVedioNoHighlightButton *btn  = [[FMVedioNoHighlightButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"fmvideo_icon_play"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"fmvideo_icon_pause"] forState:UIControlStateSelected];
        [self addSubview:btn];
        _playButton = btn;
    }
    return _playButton;
}

- (UILabel *)currentTimeLabel{
    if (nil == _currentTimeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"00:00";
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        _currentTimeLabel = label;
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel{
    if (nil == _totalTimeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"/00:00";
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        _totalTimeLabel = label;
    }
    return _totalTimeLabel;
}

- (UISlider *)slider{
    if (nil ==_slider) {
        UISlider *slide = [[UISlider alloc] init];
        [slide setThumbImage:[UIImage imageNamed:@"fmvideo_icon_slider"] forState:UIControlStateNormal];
        [slide setTintColor:[UIColor redColor]];
        [self addSubview:slide];
        _slider = slide;
    }
    return _slider;
}

@end

