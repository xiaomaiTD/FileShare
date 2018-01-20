//
//  UpdManager.h
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"

@interface UdpServerManager : NSObject<AsyncUdpSocketDelegate>{
    AsyncUdpSocket *_udpSocket;
}
//发送广播
- (void)sendBroadcast;
- (void)start;
- (void)close;
@end
