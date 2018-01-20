//
//  UpdManager.m
//  UpdFileTransfer
//
//  Created by wulanzhou-mini on 15-3-27.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "UdpServerManager.h"
#import "ConnectionItem.h"
@interface UdpServerManager ()
@property (nonatomic,strong) NSMutableArray *ipLists;
@end

@implementation UdpServerManager
- (void)start{
    self.ipLists=[[NSMutableArray alloc] init];
    _udpSocket=[[AsyncUdpSocket alloc]initWithDelegate:self];
    //绑定端口
    NSError *error;
    BOOL open = [_udpSocket bindToPort:kUDPPORT error:&error];
    if (!open) {
        return;
    }
    po(error);
    //绑定广播
    [_udpSocket enableBroadcast:YES error:nil];
    //加入群里，能接收到群里其他客户端的消息
    //[_udpSocket joinMulticastGroup:@"172.30.0.0" error:&error];
    //发广播
    //启动接收线程
    [_udpSocket receiveWithTimeout:-1 tag:kUdpSendBroadcast_Tag];
}
- (void)close{
    if (self.ipLists) {
        [self.ipLists removeAllObjects];
        self.ipLists=nil;
    }
    if (_udpSocket) {
        [_udpSocket close];
        _udpSocket.delegate=nil;
        _udpSocket=nil;
    }
}
-(void)sendBroadcast{
    NSString* bchost=@"255.255.255.255"; //这里发送广播
    [self sendToUDPServer:[[UIDevice currentDevice] name] address:bchost port:kUDPPORT];
}
-(void)sendToUDPServer:(NSString*) msg address:(NSString*)address port:(int)port{
    //发广播
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:address port:port withTimeout:-1 tag:kUdpSendBroadcast_Tag]; //发送udp
}
#pragma mark -
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSString* rData= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"onUdpSocket:didReceiveData:host---%@",host);
    NSLog(@"onUdpSocket:didReceiveData:port---%d",port);
    NSLog(@"onUdpSocket:didReceiveData:tag---%ld",tag);
    NSLog(@"onUdpSocket:didReceiveData:---%@",rData);
    //[_udpSocket receiveWithTimeout:-1 tag:kUdpSendBroadcast_Tag]; //启动监听下一条消息

    ConnectionItem *mod=[[ConnectionItem alloc] init];
    mod.name=rData;
    mod.host=[ConnectionItem formatHost:host];
    mod.port=port;
    mod.systemName=@"IOS";
    NSString *currentIP=IPAddress();
    if (![currentIP isEqualToString:mod.host]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationIPReceivedFinishd object:mod userInfo:nil];
    }
    
    /**
    if (![self.ipLists containsObject:host]) {
        NSString *currentIP=[DeviceInfo IPAddress];
 
        NSString *locHost=host;
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:host options:0 range:NSMakeRange(0, [host length])];
        if (result) {
            locHost=[host substringFromIndex:result.range.location];
        }
        if (![currentIP isEqualToString:locHost]) {
            [self.ipLists addObject:locHost];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationIPReceivedFinishd object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:locHost,@"host", nil]];
        }
    }
     **/
    return YES;
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotSendDataWithTag----%ld,error=%@",tag,error.description);
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceiveDataWithTag----%ld",tag);
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"didSendDataWithTag----%ld",tag);
}
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"onUdpSocketDidClose----");
}
@end
