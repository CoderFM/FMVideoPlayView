//
//  FMVedioBottomToolBar.h
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const  FMVedioBottomToolBarHeight = 30;
static CGFloat const  FMVedioBottomToolBarNormalMargin = 10;

@interface FMVedioNoHighlightButton : UIButton

@end

@interface FMVedioBottomToolBar : UIView

@property(nonatomic, weak)FMVedioNoHighlightButton *fullScreenButton;

@property(nonatomic, weak)FMVedioNoHighlightButton *playButton;

@property(nonatomic, weak)UISlider *slider;

@property(nonatomic, weak)UILabel *totalTimeLabel;

@property(nonatomic, weak)UILabel *currentTimeLabel;

- (void)setCurrentTime:(NSString *)currentTime totalTime:(NSString *)totalTime;

@end
