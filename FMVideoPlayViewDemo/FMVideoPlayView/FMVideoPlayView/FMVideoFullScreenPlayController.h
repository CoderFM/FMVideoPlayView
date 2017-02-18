//
//  FMVideoFullScreenPlayController.h
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class FMVideoPlayView;
@interface FMVideoFullScreenPlayController : UIViewController

@property(nonatomic,  copy)void(^exitFullscreenModelBlock)();

@property(nonatomic, weak)FMVideoPlayView *playView;

@property(nonatomic, weak)FMVideoPlayView *sourcePlayView;

- (instancetype)initWithCurrentItem:(AVPlayerItem *)currentItem;

@end
