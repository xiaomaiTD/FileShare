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

@property(nonatomic,assign)NSInteger currentPage;

@property(nonatomic,assign,readonly)NSUInteger pageCount;

@property(nonatomic,strong)NSMutableArray *pageArray;


-(NSString *)stringOfPage:(NSUInteger)index;

-(void)dividePageWithBounds:(CGRect)bounds;



-(instancetype)initWithContentString:(NSString *)content;

+(instancetype)getLocalModelWithUrl:(NSURL *)url;

@end
