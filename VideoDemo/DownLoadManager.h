//
//  DownLoadManager.h
//  VideoDemo
//
//  Created by ChenQing on 17/8/13.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSString *fileStorePath,NSInteger totalLength);

typedef void(^FaileBlock)(NSError *error);

typedef void(^ProgressBlock)(float progress);

@interface DownLoadManager : NSObject<NSURLSessionDataDelegate>

@property (copy) SuccessBlock successBlock;
@property (copy) FaileBlock faileBlock;
@property (copy) ProgressBlock progressBlock;

+(instancetype)shareInstance;

-(void)downLoadWithURL:(NSString *)url
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)successBlock
                  faile:(FaileBlock)faileBlock;
-(void)stopTask;

@end
