//
//  DataBaseTool.m
//  POSystem
//
//  Created by 掌上先机 on 17/2/15.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "DataBaseTool.h"

static DataBaseTool *tool;
static NSUserDefaults *UserDefault;

@implementation DataBaseTool

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[DataBaseTool alloc] init];
        UserDefault = [NSUserDefaults standardUserDefaults];
    });
    return tool;
}
-(void)setIPAddree:(NSString *)ip{
    [self setObjet:ip forKey:@"ipAddress"];
}

-(NSString *)getIpAddress{
    return [self getObjectForKey:@"ipAddress"];
}

-(void)setObjet:(id)object forKey:(NSString *)key{
    [UserDefault setObject:object forKey:key];
    [UserDefault synchronize];
}

-(id)getObjectForKey:(NSString *)key{
    return [UserDefault objectForKey:key];
}

@end
