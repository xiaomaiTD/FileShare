//
//  ConnectionItem.m
//  UpdFileTransfer
//
//  Created by rang on 15-3-28.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "ConnectionItem.h"

@implementation ConnectionItem
- (NSString*)GetRemoteAddress{
    NSString *url=[NSString stringWithFormat:@"http://%@:%d",self.host,self.port];
    return url;
}
//主机格式化
+ (NSString*)formatHost:(NSString*)str{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    if (result) {
        return [str substringFromIndex:result.range.location];
    }
    return str;
}
@end
