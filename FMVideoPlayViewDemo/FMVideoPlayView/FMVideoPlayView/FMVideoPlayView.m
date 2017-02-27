//
//  FMVedioPlayView.m
//  横屏播放视频
//
//  Created by 周发明 on 16/11/8.
//  Copyright © 2016年 周发明. All rights reserved.
//

#import "FMVideoPlayView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FMVedioBottomToolBar.h"
#import "FMVedioTopToolBar.h"
#import "FMVideoFullScreenPlayController.h"
#import "FMVedioNoHighlightButton.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>


NSString *GetTimeStringWithSeconds(float seconds){
    if (isnan(seconds)){
        return @"00:00";
    }
    NSInteger sec = (NSInteger)seconds % 60;
    NSInteger min = ((NSInteger)seconds / 60) % 60;
    NSInteger hour = (NSInteger)seconds / 3600;
    if (hour > 0) { // 超过一个小时
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)min, (long)sec];
    } else { // 没有超过一个小时
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
    }
}

@interface FMVideoPlayView ()

@property(nonatomic, weak)AVPlayerLayer *playerLayer;

@property(nonatomic, weak)UIButton *fullScreenButton;

@property(nonatomic, assign)CGRect originalFrame;

@property(nonatomic, weak)FMVedioBottomToolBar *bottomView;

@property(nonatomic, weak)FMVedioTopToolBar *topView;

@property(nonatomic, weak)NSTimer *timer;

@property(nonatomic, assign)BOOL isLayout;

@property(nonatomic, assign)CGPoint currentLocationPoint;

@property(nonatomic, assign)FMVideoPlayViewLocation currentLocation;
@property(nonatomic, assign)FMVideoPlayViewPanModel currentPanModel;

@property(nonatomic, weak)UISlider *volumeSlider;

@property(nonatomic, weak)UIViewController *sourceVC;

@property(nonatomic, weak)AVPlayer *player;

@property(nonatomic, weak)CADisplayLink *displayLink;

@end

uint32_t lastBytes = 0;

@implementation FMVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame sourceController:(UIViewController *)sourceVC currentItemUrl:(NSString *)url{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playError:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap2count = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2count:)];
        tap2count.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap2count];
        [tap requireGestureRecognizerToFail:tap2count];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        [self bottomView];
        [self topView];
        self.sourceVC = sourceVC;
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
        [self.player replaceCurrentItemWithPlayerItem:item];
        
        [self displayLink];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame sourceController:nil currentItemUrl:@""];
}

- (void)rePlaceCurrentItemWithItem:(AVPlayerItem *)item{
    [self.player replaceCurrentItemWithPlayerItem:item];
}

- (void)synchronizeCurrentTime:(CMTime)currentTime{
    [self.player.currentItem seekToTime:currentTime];
}

- (void)play{
    [self.playerLayer.player play];
    [self timer];
    self.bottomView.playButton.selected = YES;
}

- (void)pause{
    self.bottomView.playButton.selected = NO;
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
}

- (void)playError:(NSNotification *)noti{
    NSLog(@"noti: %@", noti);
}

- (void)tap:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomView.hidden = !self.bottomView.isHidden;
    }];
}

- (void)tap2count:(UITapGestureRecognizer *)tap{
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait){
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey: @"orientation"];
        [self.fullscreenVC.playView synchronizeCurrentTime:self.player.currentItem.currentTime];
        [self.fullscreenVC.playView setCurrentTime];
        [self pause];
        [self.sourceVC presentViewController:self.fullscreenVC animated:YES completion:^{
            [self.fullscreenVC.playView play];
        }];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint location = [pan locationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.currentLocation = location.x > self.bounds.size.width * 0.5;
            self.currentLocationPoint = location;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat slideDistance = 10;
            switch (self.currentPanModel) {
                case FMVideoPlayViewPanUnknownModel:
                {
                    switch (self.currentLocation) {
                        case FMVideoPlayViewLeftLocation://左边
                            if (fabs(location.y - self.currentLocationPoint.y) > slideDistance) { // 纵向滑动
                                if (location.y > self.currentLocationPoint.y){ // 纵向向下滑
                                    self.currentPanModel = FMVideoPlayViewPanBrightnessReduceModel;
                                } else { // 纵向向上滑
                                    self.currentPanModel = FMVideoPlayViewPanBrightnessAddModel;
                                }
                            } else if (fabs(location.x - self.currentLocationPoint.y) > slideDistance){ // 横向滑动
                                if (location.x > self.currentLocationPoint.x){ // 横向向前
                                    self.currentPanModel = FMVideoPlayViewPanProgressAddModel;
                                } else { // 横向向后滑
                                    self.currentPanModel = FMVideoPlayViewPanProgressReduceModel;
                                }
                            } else {
                                self.currentPanModel = FMVideoPlayViewPanUnknownModel;
                            }
                            break;
                        case FMVideoPlayViewRightLocation:// 右边
                            if (fabs(location.y - self.currentLocationPoint.y) > slideDistance) { // 纵向滑动
                                if (location.y > self.currentLocationPoint.y){ // 纵向向下滑
                                    self.currentPanModel = FMVideoPlayViewPanVolumeReduceModel;
                                } else { // 纵向向上滑
                                    self.currentPanModel = FMVideoPlayViewPanVolumeAddModel;
                                    [self _volumeChangeAdd:YES];
                                }
                            } else if (fabs(location.x - self.currentLocationPoint.y) > slideDistance){ // 横向滑动
                                if (location.x > self.currentLocationPoint.x){ // 横向向前滑
                                    self.currentPanModel = FMVideoPlayViewPanProgressAddModel;
                                } else { // 横向向后滑
                                    self.currentPanModel = FMVideoPlayViewPanProgressReduceModel;
                                }
                            } else {
                                self.currentPanModel = FMVideoPlayViewPanUnknownModel;
                            }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case FMVideoPlayViewPanVolumeAddModel:
                     [self _volumeChangeAdd:YES];
                    break;
                case FMVideoPlayViewPanVolumeReduceModel:
                     [self _volumeChangeAdd:NO];
                    break;
                case FMVideoPlayViewPanBrightnessAddModel:
                    [self _brightnessChangeAdd:YES];
                    break;
                case FMVideoPlayViewPanBrightnessReduceModel:
                    [self _brightnessChangeAdd:NO];
                    break;
                case FMVideoPlayViewPanProgressAddModel:
                    [self _progressChangeAdd:YES];
                    break;
                case FMVideoPlayViewPanProgressReduceModel:
                    [self _progressChangeAdd:NO];
                    break;
                default:
                    break;
            }
            
            [pan setTranslation:CGPointZero inView:pan.view];
        }
            break;
        case UIGestureRecognizerStateEnded:
            self.currentPanModel = FMVideoPlayViewPanUnknownModel;
            break;
        default:
            break;
    }
}

- (void)_brightnessChangeAdd:(BOOL)isAdd{
    CGFloat rate = 100;
    NSInteger current = [UIScreen mainScreen].brightness * rate;
    if (isAdd) {
        current += 2;
    } else {
        current -= 2;
    }
    if (current < 0) current = 1;
    if (current > rate) current = rate;
    [UIScreen mainScreen].brightness = current / rate;
}

- (void)_volumeChangeAdd:(BOOL)isAdd{
    
    CGFloat rate = 100;
    NSInteger current = self.volumeSlider.value * rate;
    
    if (isAdd) {
        current += 5;
    } else {
        current -= 5;
    }
    if (current < 0) current = 1;
    if (current > rate) current = rate;
//    self.volumeSlider.value= current / rate;
    [self.volumeSlider setValue:current/rate animated:NO];
}

- (void)_progressChangeAdd:(BOOL)isAdd{
    CMTime currentTime = self.playerLayer.player.currentItem.currentTime;
    float seconds = CMTimeGetSeconds(currentTime);
    if (isAdd) {
        seconds += 5;
    } else {
        seconds -= 5;
    }
    [self.playerLayer.player.currentItem seekToTime:CMTimeMake(seconds, 1)];
    [self setCurrentTime];
}

- (void)setCurrentTime{
    
    CMTime duration = self.playerLayer.player.currentItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    
    CMTime currentTime = self.playerLayer.player.currentTime;
    float times = CMTimeGetSeconds(currentTime);
    
    self.bottomView.slider.value = times / seconds;
    
    [self.bottomView setCurrentTime:GetTimeStringWithSeconds(times) totalTime:GetTimeStringWithSeconds(seconds)];
    
//    [self getInterfaceBytes];
    
}

- (void)fullScreenButtonClick:(UIButton *)sender{
    if (self.directionType == FMVideoPlayViewNormalType){ // 去全屏
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey: @"orientation"];
        [self.fullscreenVC.playView synchronizeCurrentTime:self.player.currentItem.currentTime];
        [self.fullscreenVC.playView setCurrentTime];
        [self pause];
        [self.sourceVC presentViewController:self.fullscreenVC animated:YES completion:^{
            [self.fullscreenVC.playView play];
        }];
    } else {// 退出全屏
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey: @"orientation"];
        [self.fullscreenVC.sourcePlayView synchronizeCurrentTime:self.fullscreenVC.playView.player.currentItem.currentTime];
        [self.fullscreenVC.sourcePlayView setCurrentTime];
        [self.fullscreenVC dismissViewControllerAnimated:YES completion:^{
            [self.fullscreenVC.sourcePlayView play];
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

- (void)playButtonClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)exitButtonClick:(UIButton *)sender{
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight) {
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey: @"orientation"];
        [self.fullscreenVC.sourcePlayView synchronizeCurrentTime:self.fullscreenVC.playView.player.currentItem.currentTime];
        [self.fullscreenVC.sourcePlayView setCurrentTime];
        [self.fullscreenVC dismissViewControllerAnimated:YES completion:^{
            [self.fullscreenVC.sourcePlayView play];
        }];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

- (AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        NSURL *url = [NSURL URLWithString:@""];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:playerLayer];
        _playerLayer = playerLayer;
    }
    return _playerLayer;
}

- (AVPlayer *)player{
    return self.playerLayer.player;
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
        
        [view.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        [self addSubview:view];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:FMVedioBottomToolBarHeight]];
        
        _bottomView = view;
    }
    return _bottomView;
}

- (FMVedioTopToolBar *)topView{
    if (nil == _topView) {
        FMVedioTopToolBar *top = [[FMVedioTopToolBar alloc] init];
        [top.exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:top];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:top attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:top attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:top attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [top addConstraint:[NSLayoutConstraint constraintWithItem:top attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:FMVedioTopToolBarHeight]];
        _topView = top;
    }
    return _topView;
}

- (FMVideoFullScreenPlayController *)fullscreenVC{
    if (nil == _fullscreenVC) {
        _fullscreenVC = [[FMVideoFullScreenPlayController alloc] initWithCurrentItem:[self.player.currentItem copy]];
        _fullscreenVC.sourcePlayView = self;
    }
    return _fullscreenVC;
}

- (UISlider *)volumeSlider{
    if (_volumeSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        volumeView.hidden = YES;
        [self addSubview:volumeView];
        UISlider* volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        _volumeSlider = volumeViewSlider;
    }
    return _volumeSlider;
}

- (void)dealloc{
    [self.player removeObserver:self forKeyPath:@"status"];
}

@end
