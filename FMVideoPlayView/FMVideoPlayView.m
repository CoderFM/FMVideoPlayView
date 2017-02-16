//
//  FMVedioPlayView.m
//  横屏播放视频
//
//  Created by 周发明 on 16/11/8.
//  Copyright © 2016年 周发明. All rights reserved.
//

#import "FMVideoPlayView.h"
#import <AVFoundation/AVFoundation.h>

NSString *GetTimeStringWithSeconds(float seconds){
    NSInteger sec = (NSInteger)seconds % 60;
    NSInteger min = ((NSInteger)seconds / 60) % 60;
    NSInteger hour = (NSInteger)seconds / 3600;
    if (hour > 0) { // 超过一个小时
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
    } else { // 没有超过一个小时
        return [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }
}

@interface FMVedioBottomToolBar : UIView

@property(nonatomic, weak)UIButton *fullScreenButton;

@property(nonatomic, weak)UIButton *playButton;

@property(nonatomic, weak)UISlider *slider;

@property(nonatomic, weak)UILabel *totalTimeLabel;

@property(nonatomic, weak)UILabel *currentTimeLabel;

- (void)setCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime;

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

- (UIButton *)fullScreenButton{
    if (_fullScreenButton == nil) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[[UIImage imageNamed:@"full"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:btn];
        _fullScreenButton = btn;
    }
    return _fullScreenButton;
}

- (UIButton *)playButton{
    if (nil == _playButton) {
        UIButton *btn  = [[UIButton alloc] init];
        [btn setTitle:@"播放" forState:UIControlStateNormal];
        [btn setTitle:@"暂停" forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn sizeToFit];
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
        [self addSubview:label];
        _totalTimeLabel = label;
    }
    return _totalTimeLabel;
}

- (UISlider *)slider{
    if (nil ==_slider) {
        UISlider *slide = [[UISlider alloc] init];
        [self addSubview:slide];
        _slider = slide;
    }
    return _slider;
}

@end

@interface FMVideoPlayView ()

@property(nonatomic, weak)AVPlayerLayer *playerLayer;

@property(nonatomic, weak)UIButton *fullScreenButton;

@property(nonatomic, assign)CGRect originalFrame;

@property(nonatomic, weak)FMVedioBottomToolBar *bottomView;

@property(nonatomic, weak)NSTimer *timer;

@property(nonatomic, assign)BOOL isLayout;

@end

@implementation FMVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playError:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
        
        [self.playerLayer.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [self addGestureRecognizer:tap];
        
        [self bottomView];
        
    }
    return self;
}

- (void)play{
    [self.playerLayer.player play];
    [self timer];
}

- (void)pause{
    [self.playerLayer.player pause];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    /*
    AVPlayerStatusUnknown,   无法播放视频
    AVPlayerStatusReadyToPlay,   准备播放
    AVPlayerStatusFailed*/    //播放失败
    
    switch ([change[@"new"] integerValue]) {
        case AVPlayerStatusUnknown:
            
            break;
        case AVPlayerStatusReadyToPlay:
            [self setCurrentTime];
            break;
        case AVPlayerStatusFailed:
            
            break;
        default:
            break;
    }
    NSLog(@"change:  %@", change);
}

- (void)playError:(NSNotification *)noti{
    NSLog(@"noti: %@", noti);
}

- (void)tap:(UITapGestureRecognizer *)tap{
    self.bottomView.hidden = !self.bottomView.isHidden;
}

- (void)setCurrentTime{
    
    CMTime duration = self.playerLayer.player.currentItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    CMTime currentTime = self.playerLayer.player.currentTime;
    float times = CMTimeGetSeconds(currentTime);
    
    self.bottomView.slider.value = times / seconds;
    
    [self.bottomView setCurrentTime:GetTimeStringWithSeconds(times) totalTime:GetTimeStringWithSeconds(seconds)];
}

- (void)fullScreenButtonClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    CGFloat Screen_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat Screen_height = [UIScreen mainScreen].bounds.size.height;
    if  (sender.isSelected){
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(- (Screen_height - Screen_width) * 0.5,  (Screen_height - Screen_width) * 0.5, Screen_height, Screen_width);
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectMake(0,  0, Screen_width, 200);
        }];
    }
}

- (void)sliderValueChange:(UISlider *)sender{
    CGFloat value = sender.value;
    CMTime duration = self.playerLayer.player.currentItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    CMTime currentTime = CMTimeMake(seconds * value, 1);
    [self.playerLayer.player.currentItem seekToTime:currentTime];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
//        NSURL *url =  [[NSBundle mainBundle] URLForResource:@"02" withExtension:@"mov"];
        NSURL *url = [NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:playerLayer];
        _playerLayer = playerLayer;
    }
    return _playerLayer;
}

- (NSTimer *)timer{
    if (nil == _timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(setCurrentTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (FMVedioBottomToolBar *)bottomView{
    
    if (_bottomView == nil) {
        
        FMVedioBottomToolBar *view = [[FMVedioBottomToolBar alloc] init];
        
        [view.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        
        [self addSubview:view];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:FMVedioBottomToolBarHeight]];
        
        _bottomView = view;
    }
    return _bottomView;
}

@end
