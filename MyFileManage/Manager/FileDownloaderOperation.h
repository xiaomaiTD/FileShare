//
//  FileDownloader.h
//  MyFileManage
//
//  Created by Viterbi on 2018/4/26.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMBClient/SMBClient.h>

@interface FileDownloaderOperation : NSObject

-(instancetype)initWithFile:(SMBFile *)file;

@end
