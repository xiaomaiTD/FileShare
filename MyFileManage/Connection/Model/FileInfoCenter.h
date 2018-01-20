//
//  FileInfoCenter.h
//  UpdFileTransfer
//
//  Created by rang on 15-3-29.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNotificationFileSendStatuChanged   @"kNotificationFileSendStatuChanged"

typedef enum{
    FileSending=0,// 发送中
    FileSendPause,//暂停
    FileSendSuccess,//发送成功
    FileSendFailed//发送失败
}FileSendStatus;


@interface FileInfoCenter : NSObject
@property (nonatomic,strong) NSString *fileName;//文件名
@property (nonatomic,strong) NSString *fileSize;//文件大小
@property (nonatomic,strong) UIImage *thumbImage;//缩略图
@property (nonatomic,assign) FileSendStatus sendStauts;//文件发送状态
@end
