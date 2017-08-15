//
//  MusicPlayerViewController.m
//  VideoDemo
//
//  Created by ChenQing on 17/8/15.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "XYAVPlayer.h"

@interface MusicPlayerViewController (){
    XYAVPlayer *player;
}

@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,strong) UIButton *startBtn;

@property (nonatomic,strong) UIButton *stopBtn;

@property (nonatomic,strong) UIButton *nextBtn;

@end

@implementation MusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutView];
    player=[[XYAVPlayer alloc]initWith:self.view.frame urlString:@"http://audio.xmcdn.com/group11/M01/93/AF/wKgDa1dzzJLBL0gCAPUzeJqK84Y539.m4a" aboveView:self.view];
    // http://sc1.111ttt.com/2017/4/05/10/298101104389.mp3
    // http://audio.xmcdn.com/group11/M01/93/AF/wKgDa1dzzJLBL0gCAPUzeJqK84Y539.m4a
    
    
}

-(void)layoutView{
    _startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame=CGRectMake(50, 80, 40, 40);
    [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    _startBtn.titleLabel.font=[UIFont systemFontOfSize:15] ;
    _startBtn.backgroundColor=[UIColor redColor];
    [_startBtn addTarget:self action:@selector(buttonStart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    
    
    _stopBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn.frame=CGRectMake(150, 80, 40, 40);
    [_stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_stopBtn setTitle:@"暂停" forState:UIControlStateNormal];
    _stopBtn.titleLabel.font=[UIFont systemFontOfSize:15] ;
    _stopBtn.backgroundColor=[UIColor grayColor];
    [_stopBtn addTarget:self action:@selector(buttonStop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopBtn];
    
    _nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame=CGRectMake(250, 80, 80, 40);
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"下一首" forState:UIControlStateNormal];
    _nextBtn.titleLabel.font=[UIFont systemFontOfSize:15] ;
    _nextBtn.backgroundColor=[UIColor grayColor];
    [_nextBtn addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    _slider=[[UISlider alloc]initWithFrame:CGRectMake(50, 250, 200, 25)];
    [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
}

-(void)buttonStart:(UIButton *)btn{
    [player start];
}

-(void)buttonStop:(UIButton *)btn{
    [player stop];
}

-(void)buttonNext:(UIButton *)btn{
    [player repleaceVideoWithURLString:@"http://audio.xmcdn.com/group11/M01/93/AF/wKgDa1dzzJLBL0gCAPUzeJqK84Y539.m4a"];
}

-(void)sliderChange:(UISlider *)sli{
    player.sumPlayOperation=player.player.currentItem.duration.value/player.player.currentItem.duration.timescale;
    [player.player seekToTime:CMTimeMakeWithSeconds(sli.value*player.sumPlayOperation, player.player.currentItem.duration.timescale) completionHandler:^(BOOL finished) {
        [player start];
    }];
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
