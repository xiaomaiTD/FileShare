//
//  FileDownloadManager.h
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMBClient/SMBClient.h>

typedef void(^FileDownloadComplete)(NSData *fileData);
typedef BOOL(^FileDownLoadProgress)(unsigned long long bytesReadTotal, NSData *data, BOOL complete, NSError *error);

@interface FileDownloadManager : NSObject

+(instancetype)shareInstance;

-(void)downloadFileWithFile:(SMBFile *)file andDowloadComplete:(FileDownloadComplete)downloadComplete;

@end
