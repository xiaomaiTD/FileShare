//
//  readTXTModel.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/14.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadTXTModel : NSObject<NSCoding>


@property(nonatomic,copy)NSString *content;

-(instancetype)initWithContentString:(NSString *)content;

+(instancetype)getLocalModelWithUrl:(NSURL *)url;

@end
