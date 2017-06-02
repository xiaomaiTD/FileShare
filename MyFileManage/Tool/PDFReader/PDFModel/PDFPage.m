//
//  PDFPage.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/1.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFPage.h"

@implementation PDFPage


- (CGRect)rect
{
    CGRect rect = CGPDFPageGetBoxRect(self.CGPDFPage, kCGPDFMediaBox);
    return rect;
}

- (void)dealloc
{
    CGPDFPageRelease(_CGPDFPage);
}

- (instancetype)initWithCGPDFPage:(CGPDFPageRef)CGPDFPage
{
    self = [super init];
    if (self) {
        _CGPDFPage = CGPDFPageRetain(CGPDFPage);
    }
    return self;
}

- (NSUInteger)index
{
    size_t pageNumber = CGPDFPageGetPageNumber(self.CGPDFPage);
    return (NSUInteger)pageNumber;
}


@end
