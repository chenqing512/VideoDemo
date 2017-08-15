//
//  XYAVPlayer.h
//  VideoDemo
//
//  Created by ChenQing on 17/8/15.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


@interface XYAVPlayer : NSObject

/*
 * AVPlayer
 */
@property (nonatomic,strong) AVPlayer *player;
/*
 * AVPlayerItem
 */
@property (nonatomic,strong) AVPlayerItem *playerItem;
/*
 * AVPlayerLayer
 */
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

/*
 * 播放总时长
 */
@property (nonatomic,assign) CGFloat sumPlayOperation;

/*
 * 播放视频的方法
 */

-(instancetype)initWith:(CGRect)frame urlString:(NSString *)urlStr aboveView:(UIView *)view;
/*
 * 更新视频
 */
-(void)repleaceVideoWithURLString:(NSString *)urlStr;

-(void)start;

-(void)stop;

@end
