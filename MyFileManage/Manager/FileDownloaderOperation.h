//
//  FileDownloader.h
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMBClient/SMBClient.h>

typedef void(^FileDownloadComplete)(NSData *fileData);
typedef BOOL(^FileDownLoadProgress)(unsigned long long bytesReadTotal, NSData *data, BOOL complete, NSError *error);


@interface FileDownloaderOperation : NSOperation

-(instancetype)initWithFile:(SMBFile *)file andProgress:(FileDownLoadProgress)press andDownloadComplete:(FileDownloadComplete)complete;

@end
