//
//  PDFPageViewController.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/2.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFPage.h"


@interface PDFPageViewController : UIViewController

@property (nonatomic, strong, readonly) PDFPage *page;

-(instancetype)initWithPage:(PDFPage *)page;

@end
