//
//  ViewController.m
//  FMVideoPlayView
//
//  Created by 周发明 on 17/2/16.
//  Copyright © 2017年 周发明. All rights reserved.
//

#import "ViewController.h"
#import "FMVideoPlayView.h"
#import "FMVideoFullScreenPlayController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    FMVideoPlayView *view = [[FMVideoPlayView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) sourceController:self currentItemUrl:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)turnController:(id)sender {
    
}



@end
