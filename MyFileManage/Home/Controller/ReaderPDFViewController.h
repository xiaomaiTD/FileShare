//
//  ReaderPDFViewController.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/31.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFDocument.h"


@interface ReaderPDFViewController : UIViewController

@property (nonatomic, strong) PDFDocument *document;
@property(nonatomic,strong)NSString *pdfPath;

@end
