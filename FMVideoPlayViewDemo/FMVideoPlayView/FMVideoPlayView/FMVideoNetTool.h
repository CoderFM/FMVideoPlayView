//
//  FMVideoNetTool.h
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/21.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMVideoNetTool : NSObject

+ (void)downloadVideoWithUrl:(NSString *)url toFilePath:(NSString *)filePath;

@end
