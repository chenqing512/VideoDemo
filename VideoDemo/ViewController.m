//
//  ViewController.m
//  VideoDemo
//
//  Created by ChenQing on 17/8/13.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // http://10003ah.media1.z1.pili.qiniucdn.com/recordings/z1.live-tuoniao.testhuser302/testhuser302_1494313529.m3u8
    // http://audio.xmcdn.com/group11/M01/93/AF/wKgDa1dzzJLBL0gCAPUzeJqK84Y539.m4a
    [[DownLoadManager shareInstance] downLoadWithURL:@"http://10003ah.media1.z1.pili.qiniucdn.com/recordings/z1.live-tuoniao.testhuser302/testhuser302_1494313529.m3u8" progress:^(float progress) {
        NSLog(@"###%f",progress);
    } success:^(NSString *fileStorePath,NSInteger totalLength) {
        NSLog(@"###文件路径%@ 大小%zd",fileStorePath,totalLength);
    } faile:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
