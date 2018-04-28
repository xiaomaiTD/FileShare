//
//  FileDownloader.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FileDownloaderOperation.h"

@interface FileDownloaderOperation()

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property(nonatomic,strong)SMBFile *sfile;
@property(nonatomic,strong)FileDownloadComplete downloadComplete;
@property(nonatomic,strong)FileDownLoadProgress downloadProgress;

@end

@implementation FileDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;


-(instancetype)initWithFile:(SMBFile *)file andProgress:(FileDownLoadProgress)press andDownloadComplete:(FileDownloadComplete)complete{
    
    if (self = [super init]) {
        self.sfile = file;
        [self start];
        
        self.downloadProgress = press;
        self.downloadComplete = complete;
        
    }
    return self;
}

-(void)start{
  
    @synchronized(self){
        
        if (self.isCancelled) {
            self.finished = YES;
            return;
        }
        if (!self.sfile) {
            return;
        }
        NSUInteger bufferSize = 12000;
        NSMutableData *muteData = [[NSMutableData alloc] init];
        
        [self.sfile open:SMBFileModeRead completion:^(NSError * _Nullable error) {
            
            if (!error) {
                
                [self.sfile read:bufferSize progress:^BOOL(unsigned long long bytesReadTotal, NSData * _Nullable data, BOOL complete, NSError * _Nullable error) {
                    
                    NSLog(@"file-----%@",self.sfile.path);
                    
                    if (error) {
                        return NO;
                    }
                    [muteData appendData:data];
                    if (complete) {
                        [self.sfile close:nil];
                        self.downloadComplete(muteData);
                        NSDictionary *info = @{@"file":self.sfile};
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SMBFileDownloadComplete" object:nil userInfo:info];
                        return YES;
                    }
                    self.downloadProgress(bytesReadTotal, data, complete, error);
                    return YES;
                }];
            }
            
        }];

    }
}
- (void)setFinished:(BOOL)finished {
  [self willChangeValueForKey:@"isFinished"];
  _finished = finished;
  [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
  [self willChangeValueForKey:@"isExecuting"];
  _executing = executing;
  [self didChangeValueForKey:@"isExecuting"];
}

-(BOOL)isConcurrent{
  return YES;
}

@end
