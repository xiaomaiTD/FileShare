//
//  FileInfoCenter.m
//  UpdFileTransfer
//
//  Created by rang on 15-3-29.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "FileInfoCenter.h"

@implementation FileInfoCenter
- (void)setSendStauts:(FileSendStatus)status
{
    if (_sendStauts!=status) {
        _sendStauts=status;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFileSendStatuChanged object:self];
    }
}
@end
