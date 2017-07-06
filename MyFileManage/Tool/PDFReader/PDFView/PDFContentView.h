//
//  PDFContentView.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/6.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFCATiledLayer.h"


#import "PDFPage.h"


@interface PDFContentView : UIView


@property(nonatomic,strong,readonly)PDFPage *page;

-(instancetype)initWithPage:(PDFPage *)page;



@end
