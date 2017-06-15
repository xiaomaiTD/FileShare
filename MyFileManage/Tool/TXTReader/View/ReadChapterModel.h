//
//  ReadChapterModel.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/15.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadChapterModel : NSObject


@property(nonatomic,copy)NSString *content;

@property(nonatomic,assign,readonly)NSUInteger pageCount;


-(NSString *)stringOfPage:(NSUInteger)index;

-(void)dividePageWithBounds:(CGRect)bounds;

@end
