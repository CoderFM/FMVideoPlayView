//
//  FMVideoFullScreenPlayController.m
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/17.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "FMVideoFullScreenPlayController.h"
#import "FMVideoPlayView.h"

@interface FMVideoFullScreenPlayController ()

@end

@implementation FMVideoFullScreenPlayController

- (instancetype)initWithCurrentItem:(AVPlayerItem *)currentItem{
    if (self = [super init]) {
        [self.playView rePlaceCurrentItemWithItem:currentItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playView pause];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.playView setFrame:self.view.bounds];
}

- (FMVideoPlayView *)playView{
    if (_playView == nil) {
        FMVideoPlayView *view = [[FMVideoPlayView alloc] init];
        view.directionType = FMVideoPlayViewFullscreenType;
        view.fullscreenVC = self;
        [self.view addSubview:view];
        _playView = view;
    }
    return _playView;
}

@end
