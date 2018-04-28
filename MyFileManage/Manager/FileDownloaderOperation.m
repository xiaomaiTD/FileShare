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


@end

@implementation FileDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;


-(instancetype)initWithFile:(SMBFile *)file{
    if (self = [super init]) {
        self.sfile = file;
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
        NSMutableData *result = [NSMutableData new];
        [self.sfile open:SMBFileModeRead completion:^(NSError * _Nullable error) {
            [self.sfile read:bufferSize
                progress:^BOOL(unsigned long long bytesReadTotal, NSData *data, BOOL complete, NSError *error) {
                    
                    if (error) {
                        NSLog(@"Unable to read from the file: %@", error);
                    } else {
                        NSLog(@"Read %ld bytes, in total %llu bytes (%0.2f %%)",
                              data.length, bytesReadTotal, (double)bytesReadTotal / self.sfile.size * 100);
                        if (data) {
                            [result appendData:data];
                        }
                    }
                    
                    if (complete) {
                        [self.sfile close:^(NSError *error) {
                            NSLog(@"Finished reading file");
                        }];
                    }
                    return YES;
                }];
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
