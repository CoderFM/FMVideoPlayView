//
//  FMVedioPlayView.h
//  横屏播放视频
//
//  Created by 周发明 on 16/11/8.
//  Copyright © 2016年 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const  FMVedioBottomToolBarHeight = 30;
static CGFloat const  FMVedioBottomToolBarNormalMargin = 10;

@interface FMVideoPlayView : UIView

- (void)play;

- (void)pause;

@end
