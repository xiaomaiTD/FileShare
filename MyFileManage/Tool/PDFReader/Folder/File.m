//
//  File.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/1.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "File.h"

@implementation File

-(instancetype)initWithPath:(NSString *)path{

    if (self = [super init]) {
        
        _path = path;
        
    }
    return self;


}

-(NSString *)name{

    return self.path.lastPathComponent;

}

@end
