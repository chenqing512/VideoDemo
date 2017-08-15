//
//  XYAVPlayer.m
//  VideoDemo
//
//  Created by ChenQing on 17/8/15.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "XYAVPlayer.h"
#import <AVKit/AVKit.h>

@interface XYAVPlayer ()
/*
 * 视频 frame
 */
@property (nonatomic,assign) CGRect frame;
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) UIView *aboveView;

@property (nonatomic,assign) id timeObserver;



@end

@implementation XYAVPlayer

-(instancetype)initWith:(CGRect)frame urlString:(NSString *)urlStr aboveView:(UIView *)view{
    if (self=[super init]) {
        self.frame=frame;
        self.urlStr=urlStr;
        //self.aboveView=view;
    }
    return self;
}

#pragma mark --getter--

-(AVPlayerItem *)playerItem{
    if (!_playerItem) {
        _playerItem=[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:_urlStr]];
    }
    return _playerItem;
}

-(AVPlayer *)player{
    if (!_player) {
        _player=[[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    }
    return _player;
}
-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame=self.frame;
        _playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
        [self.aboveView.layer addSublayer:self.playerLayer];
    }
    return _playerLayer;
}

-(void)repleaceVideoWithURLString:(NSString *)urlStr{
    //移除监听
   // [self currentItemRemoveObserve];
    //创建要播放的资源
    AVPlayerItem *playItem=[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlStr]];
    //播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playItem];
    //添加观察者
  //  [self currentItemAddObserver];
}

-(void)currentItemRemoveObserve{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player removeTimeObserver:self.timeObserver];
}

-(void)currentItemAddObserver{
    //监控状态属性
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    //监控缓冲加载情况属性
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //监控时间进度
   // __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 在这里将监听到的播放进度代理出去，对进度条进行设置
        
    }];
    
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                // 开始播放
                [_player play];
                // 代理回调，开始初始化状态
//                if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayWithplayer:)]) {
//                    [self.delegate startPlayWithplayer:self.player];
//                }
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"加载失败");
               
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知资源");
               
            }
                break;
            default:
                break;
        }
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",totalBuffer);
//        if (self.delegate && [self.delegate respondsToSelector:@selector(updateBufferProgress:)]) {
//            [self.delegate updateBufferProgress:totalBuffer];
//        }
        
    } else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        float rate = self.player.rate;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(player:changeRate:)]) {
//            [self.delegate player:self.player changeRate:rate];
//        }
    } else if ([keyPath isEqualToString:@"currentItem"]) {
        NSLog(@"新的currentItem");
//        if (self.delegate && [self.delegate respondsToSelector:@selector(changeNewPlayItem:)]) {
//            [self.delegate changeNewPlayItem:self.player];
//        }
    }
}

-(void)playbackFinished:(id)sender{
    NSLog(@"播放完成");
}

#pragma mark 开始播放
-(void)start{
    [self.player play];
}
#pragma  mark 暂停播放
-(void)stop{
    [self.player pause];
}
#pragma mark 改变进度


@end
