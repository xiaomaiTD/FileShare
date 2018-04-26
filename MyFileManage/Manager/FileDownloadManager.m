//
//  FileDownloadManager.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FileDownloadManager.h"

@implementation FileDownloadManager

static FileDownloadManager *manager = nil;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FileDownloadManager shareInstance] init];
    });
    return manager;
}


/*
 NSUInteger bufferSize = 12000;
 NSMutableData *result = [NSMutableData new];
 [smfile open:SMBFileModeRead completion:^(NSError * _Nullable error) {
 [smfile read:bufferSize
 progress:^BOOL(unsigned long long bytesReadTotal, NSData *data, BOOL complete, NSError *error) {
 
 if (error) {
 NSLog(@"Unable to read from the file: %@", error);
 } else {
 NSLog(@"Read %ld bytes, in total %llu bytes (%0.2f %%)",
 data.length, bytesReadTotal, (double)bytesReadTotal / smfile.size * 100);
 if (data) {
 [result appendData:data];
 }
 }
 
 if (complete) {
 [smfile close:^(NSError *error) {
 NSLog(@"Finished reading file");
 }];
 }
 return YES;
 }];
 }];

 */

-(void)downloadFileWithFile:(SMBFile *)file andDowloadComplete:(FileDownloadComplete)downloadComplete{
    
}


@end
