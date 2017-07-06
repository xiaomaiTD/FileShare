//
//  PDFContentView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/6.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFContentView.h"


@interface PDFContentView()


@property(nonatomic,strong)PDFPage *page;


@end

@implementation PDFContentView

-(instancetype)initWithPage:(PDFPage *)page{


    if (self = [super init]) {
        

        
        _page = page;
 
    }
 
    return self;


}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{


    [_page drawInRect:self.bounds inContext:ctx cropping:NO];


}

+(Class)layerClass
{


    return [PDFCATiledLayer class];

}



@end
