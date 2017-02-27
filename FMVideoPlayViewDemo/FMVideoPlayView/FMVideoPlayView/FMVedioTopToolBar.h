//
//  FMVedioTopToolBar.h
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/20.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const  FMVedioTopToolBarHeight = 30;
static CGFloat const  FMVedioTopToolBarNormalMargin = 10;
static CGFloat const  FMVedioTopToolBarExitButtonWidth = 50;

@class FMVedioNoHighlightButton;
@interface FMVedioTopToolBar : UIView
@property(nonatomic, weak)FMVedioNoHighlightButton *exitButton;
@end
