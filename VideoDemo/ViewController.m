//
//  ViewController.m
//  VideoDemo
//
//  Created by ChenQing on 17/8/13.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "ViewController.h"
#import "DownLoadViewController.h"
#import "MusicPlayerViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mTableView;
    NSMutableArray *mDataArray;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"音视频";
    mTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTableView.delegate=self;
    mTableView.dataSource=self;
    [self.view addSubview:mTableView];
    mDataArray=[[NSMutableArray alloc]initWithObjects:@[@"下载",@"DownLoadViewController"],@[@"音乐播放",@"MusicPlayerViewController"], nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    }
    cell.textLabel.text=mDataArray[indexPath.row][0];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ctlStr=[NSString stringWithFormat:@"%@",mDataArray[indexPath.row][1]];
    UIViewController *controller=[[NSClassFromString(ctlStr) alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
