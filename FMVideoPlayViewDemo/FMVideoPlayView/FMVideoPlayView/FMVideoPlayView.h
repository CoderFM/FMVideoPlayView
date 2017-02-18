//
//  FMVedioPlayView.h
//  横屏播放视频
//
//  Created by 周发明 on 16/11/8.
//  Copyright © 2016年 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, FMVideoPlayViewDirectionType){
    FMVideoPlayViewNormalType,
    FMVideoPlayViewFullscreenType,
};

typedef NS_ENUM(NSInteger, FMVideoPlayViewLocation){
    FMVideoPlayViewLeftLocation,
    FMVideoPlayViewRightLocation
};

typedef NS_ENUM(NSInteger, FMVideoPlayViewPanModel){
    FMVideoPlayViewPanUnknownModel,
    FMVideoPlayViewPanVolumeAddModel,
    FMVideoPlayViewPanVolumeReduceModel,
    FMVideoPlayViewPanBrightnessAddModel,
    FMVideoPlayViewPanBrightnessReduceModel,
    FMVideoPlayViewPanProgressAddModel,
    FMVideoPlayViewPanProgressReduceModel
};

@class FMVideoFullScreenPlayController;
@interface FMVideoPlayView : UIView

@property(nonatomic, assign)FMVideoPlayViewDirectionType directionType;

@property(nonatomic, strong)FMVideoFullScreenPlayController *fullscreenVC;

- (void)play;

- (void)pause;

- (instancetype)initWithFrame:(CGRect)frame sourceController:(UIViewController *)sourceVC currentItemUrl:(NSString *)url;

- (void)rePlaceCurrentItemWithItem:(AVPlayerItem *)item;

- (void)synchronizeCurrentTime:(CMTime)currentTime;

@end
