//
//  PDFPage.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/1.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFPage : NSObject

@property (nonatomic, assign) CGPDFPageRef CGPDFPage;
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) CGRect rect;
@property (nonatomic, readonly) CGRect croppedRect;


- (instancetype)initWithCGPDFPage:(CGPDFPageRef)CGPDFPage;

@end
