//
//  FileDownloadManager.h
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FileDownloaderOperation.h"
#import <Foundation/Foundation.h>
#import <SMBClient/SMBClient.h>

@interface FileDownloadManager : NSObject

+(instancetype)shareInstance;

-(void)downloadFileWithFile:(SMBFile *)file andProgress:(FileDownLoadProgress)progress andDowloadComplete:(FileDownloadComplete)downloadComplete;

@end
