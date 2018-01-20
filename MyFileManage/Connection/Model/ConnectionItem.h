//
//  ConnectionItem.h
//  UpdFileTransfer
//
//  Created by rang on 15-3-28.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionItem : NSObject
@property (nonatomic,strong) NSString *host;//主机
@property (nonatomic,assign) UInt16 port;//端口
@property (nonatomic,strong) NSString *name;//设备名称
@property (nonatomic,strong) NSString *systemName;//ios或android

- (NSString*)GetRemoteAddress;
//主机格式化
+ (NSString*)formatHost:(NSString*)str;
@end
