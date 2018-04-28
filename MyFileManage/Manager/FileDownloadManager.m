//
//  FileDownloadManager.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FileDownloadManager.h"

#define LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define UNLOCK(lock) dispatch_semaphore_signal(lock);

static FileDownloadManager *manager = nil;

@interface FileDownloadManager()
@property (strong, nonatomic, nonnull) dispatch_semaphore_t operationsLock;
@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue;
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSString *, FileDownloaderOperation *> *URLOperations;
@end

@implementation FileDownloadManager

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FileDownloadManager alloc] init];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadComplete:) name:@"SMBFileDownloadComplete" object:nil];
    }
    return self;
}

-(void)downloadComplete:(NSNotification *)notifi{
    
    NSDictionary *info = notifi.userInfo;
    SMBFile *file = info[@"file"];
    if ([self.URLOperations objectForKey:file.path]) {
        [self.URLOperations removeObjectForKey:file.path];
    }

}

- (void)downloadFileWithFile:(SMBFile *)file andProgress:(FileDownLoadProgress)progress andDowloadComplete:(FileDownloadComplete)downloadComplete{
    
    LOCK(self.operationsLock)
    
    if ([self.URLOperations objectForKey:file.path]) {
        return;
    }
    
    FileDownloaderOperation *downloadOperate = [[FileDownloaderOperation alloc] initWithFile:file andProgress:progress andDownloadComplete:downloadComplete];
    
    [self.URLOperations setValue:downloadOperate forKey:file.path];

    UNLOCK(self.operationsLock);
}


@end
