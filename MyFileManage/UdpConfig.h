//
//  UdpConfig.h
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#ifndef UdpConfig_h
#define UdpConfig_h

#define kUDPPORT  9527  //端口
#define kUdpBroadcastIP  @"255.255.255.255"
#define kUdpSendBroadcast_Tag     0   //服务器发广播tag
#define kUdpReceivedBroadcast_Tag 1   //客户端接收到广播tag发送本身地址
#define kNotificationIPReceivedFinishd   @"kNotificationIPReceivedFinishd"  //收到客户端IP地址

/**
 待发送文件信息报文	1	待文件信息回应报文	11
 发送文件内容报文	2	接收文件内容结果报文	12
 **/

#define kFileSendWaitTag        1  //待发送文件信息报文
#define kFileReceiveWaitTag     11  //待文件信息回应报文

#define kSendFileContentTag     2 //发送文件内容报文
#define kReceiveFileContentTag  12 //接收文件内容结果报文

#ifdef DEBUG
#define CBLog(format, ...)   NSLog(format, ##__VA_ARGS__)
#else
#define CBLog(format, ...)  do{ }while(0)
#endif

#define po(obj)              CBLog(@"%@", obj)
#define pi(var_i)            CBLog(@"%d", var_i)
#define pf(var_f)            CBLog(@"%f", var_f)
#define print_function()     CBLog(@"%s", __PRETTY_FUNCTION__)

#define UPLOADSTART @"uploadstart"
#define UPLOADING @"uploading"
#define UPLOADEND @"uploadend"
#define UPLOADISCONNECTED @"uploadisconnected"


#endif
