//
//  FMVideoPlayer.m
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/18.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "FMVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface FMVideoPlayer()

@property(nonatomic, weak)AVPlayer *player;

@end

@implementation FMVideoPlayer

+ (instancetype)sharePlayer{
    static FMVideoPlayer *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FMVideoPlayer alloc] init];
    });
    return _instance;
}

+ (AVPlayer *)defaultPlayer{
    return [FMVideoPlayer sharePlayer].player;
}

- (AVPlayer *)player{
    if (nil == _player) {
        _player = [AVPlayer playerWithPlayerItem:nil];
    }
    return _player;
}

@end
