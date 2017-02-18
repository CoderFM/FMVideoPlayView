//
//  FMVideoPlayer.h
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/18.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayer;
@interface FMVideoPlayer : NSObject

//+ (instancetype)sharePlayer;

+ (AVPlayer *)defaultPlayer;

@end
