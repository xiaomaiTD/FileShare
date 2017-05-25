//
//  DataBaseTool.h
//  POSystem
//
//  Created by 掌上先机 on 17/2/15.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseTool : NSObject

+(instancetype)shareInstance;


-(void)setIPAddree:(NSString *)ip;

-(NSString *)getIpAddress;



@end
