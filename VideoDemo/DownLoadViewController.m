//
//  DownLoadViewController.m
//  VideoDemo
//
//  Created by ChenQing on 17/8/15.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "DownLoadViewController.h"
#import "DownLoadManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DownLoadViewController ()

@end

@implementation DownLoadViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
