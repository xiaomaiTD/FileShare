//
//  FileDownloadManager.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FileDownloadManager.h"
#import "FileDownloaderOperation.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

@interface FileDownloadManager()
@property (strong, nonatomic, nonnull) dispatch_semaphore_t operationsLock;
@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue;
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, FileDownloaderOperation *> *URLOperations;
@end

@implementation FileDownloadManager

static FileDownloadManager *manager = nil;

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FileDownloadManager shareInstance] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        _operationsLock = dispatch_semaphore_create(1);
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _downloadQueue.name = @"wangchao.MyFileManage.SMBFileDownloader";
        _URLOperations = [NSMutableDictionary new];
    }
    return self;
}

- (void)downloadFileWithFile:(SMBFile *)file andProgress:(FileDownLoadProgress)progress andDowloadComplete:(FileDownloadComplete)downloadComplete{
    
    
}


@end
