//
//  PDFPageScanner.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/16.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFPageScanner : NSObject

@property (nonatomic, assign) CGPDFPageRef CGPDFPage;
- (instancetype)initWithCGPDFPage:(CGPDFPageRef)CGPDFPage;

- (NSArray *)scanStringContents;


@end
