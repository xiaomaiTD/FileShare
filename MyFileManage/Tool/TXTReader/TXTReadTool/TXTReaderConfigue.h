//
//  TXTReaderConfigue.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/18.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXTReaderConfigue : NSObject<NSCoding>

+(instancetype)shareInstance;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat lineSpace;
@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,strong) UIColor *theme;


@end
