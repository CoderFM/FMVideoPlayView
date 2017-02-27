//
//  FMVideoNetTool.m
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/21.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "FMVideoNetTool.h"

static inline FMVideoNetTool *NetTool(){
    static FMVideoNetTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FMVideoNetTool alloc] init];
    });
    return _instance;
}

@interface FMVideoNetTool ()<NSURLSessionDownloadDelegate>

@property(nonatomic, strong)NSURLSession *session;

@end

@implementation FMVideoNetTool


+ (void)downloadVideoWithUrl:(NSString *)url toFilePath:(NSString *)filePath{
    [NetTool().session downloadTaskWithURL:[NSURL URLWithString:url]];
}

- (NSURLSession *)session{
    if (nil == _session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        _session = session;
    }
    return _session;
}

@end
