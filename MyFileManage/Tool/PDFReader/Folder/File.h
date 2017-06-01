//
//  File.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/1.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)UIImage *iconImage;
@property(nonatomic,assign)BOOL fileNotExist;

-(instancetype)initWithPath:(NSString *)path;

@end
