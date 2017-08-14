//
//  DownLoadManager.m
//  VideoDemo
//
//  Created by ChenQing on 17/8/13.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "DownLoadManager.h"
#import "NSString+Hash.h"

@interface DownLoadManager ()
/*下载任务*/
@property (nonatomic,strong) NSURLSessionDataTask *task;
/*session*/
@property (nonatomic,strong) NSURLSession *session;
/*写文件的流对象*/
@property (nonatomic,strong) NSOutputStream *stream;
/*文件的总大小*/
@property (nonatomic,assign) NSInteger totalLength;
@property (nonatomic,strong) NSString *downLoadUrl;

@end
//文件名（沙盒中的文件名），使用MD5哈希url生成的，这样就能保证文件名唯一
#define Filename self.downLoadUrl.md5String
//文件的存放路径
#define FileStorePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:Filename]
//使用plist文件存储文件的总字节数
#define TotalLengthPlist [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"totalLength.plist"]
//文件的已被下载的大小
#define DownLoadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:FileStorePath error:nil][NSFileSize] integerValue]

@implementation DownLoadManager

static DownLoadManager *_instance;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc]init];
    });
    return _instance;
}

-(void)downLoadWithURL:(NSString *)url
              progress:(ProgressBlock)progressBlock
               success:(SuccessBlock)successBlock
                  faile:(FaileBlock)faileBlock{
    self.progressBlock=progressBlock;
    self.faileBlock=faileBlock;
    self.successBlock=successBlock;
    self.downLoadUrl=url;
    [self.task resume];
}

-(void)stopTask{
    [self.task suspend];
}

#pragma mark getter 方法
-(NSURLSession *)session{
    if (!_session) {
        _session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    }
    return _session;
}
-(NSOutputStream *)stream{
    if (!_stream) {
        _stream=[NSOutputStream outputStreamToFileAtPath:FileStorePath append:YES];
    }
    return _stream;
}
-(NSURLSessionDataTask *)task{
    if (!_task) {
        NSInteger totalLength=[[NSDictionary dictionaryWithContentsOfFile:TotalLengthPlist][Filename] integerValue];
        if (totalLength&&DownLoadLength==totalLength) {
            NSLog(@"###文件已经下载过了");
            return nil;
        }
        //创建请求
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downLoadUrl]];
        //设置请求头
        //Range : bytes=xxx-xxx 从已经下载的长度开始到文件总长度的最后都要下载
        NSString *range=[NSString stringWithFormat:@"bytes=%zd-",DownLoadLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        _task=[self.session dataTaskWithRequest:request];
    }
    return _task;
}

#pragma mark <NSURLSessionDataDelegate>
/*
 *接收到响应
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    //打开流
    [self.stream open];
    /*
     Content-Length 字段返回的是服务器对每次客户端请求要下载文件的大小
     比如首次客户端请求下载文件A 大小为1000byte，那么第一次服务器返回的Content-Length = 1000
     客户端下载到500bytes，突然中断，再次请求的range为 bytes=500-，那么此时服务器返回的Content-Length 为500
     所以对于单个文件进行多次下载的情况（断点续传），计算文件的总大小，必须把服务器返回的Content-Length 加上本地存储的已经下载的文件大小
     */
    self.totalLength=[response.allHeaderFields[@"Content-Length"] integerValue]+DownLoadLength;
    //把此次已经下载的文件大小存储在plist文件
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:TotalLengthPlist];
    if (dict==nil) {
        dict=[NSMutableDictionary dictionary];
    }else{
        dict[Filename]=@(self.totalLength);
    }
    [dict writeToFile:TotalLengthPlist atomically:YES];
    //接受这个请求，允许接受服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}
/*
 *接收到服务器返回的数据（这个方法可能会被调用N次）
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //写入数据
    [self.stream write:data.bytes maxLength:data.length];
    
    float progress=1.0*DownLoadLength/self.totalLength;
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
    //下载进度
}
/*
 *请求完毕（成功/失败）
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        if (self.faileBlock) {
            self.faileBlock(error);
        }
        self.stream=nil;
        self.task=nil;
    }else{
        if (self.successBlock) {
            self.successBlock(FileStorePath,DownLoadLength);
        }
        //关闭流
        [self.stream close];
        self.stream=nil;
        self.task=nil;//清除任务
    }
}

@end
