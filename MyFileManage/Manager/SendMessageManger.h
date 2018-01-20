//
//  Sender.h
//  ImageTransfer
//
//  Created by ly on 13-7-8.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface SendMessageManger : NSObject

@property (nonatomic,strong) NSString  *remoteAddress;
@property (nonatomic,assign) UInt16 remotePort;

- (id)initWithRemoteAddress:(NSString *)address onPort:(UInt16)port;


/**
 待发送文件信息报文
 {
 “fileName”:”a.pdf”,
 “fileLength”: 180319
 }
 **/
- (void)waitSendFileWithName:(NSString*)name fileLength:(NSUInteger)total;
/**
 发送文件内容报文
 **/
- (void)sendFileData:(NSData *)data;
@end
