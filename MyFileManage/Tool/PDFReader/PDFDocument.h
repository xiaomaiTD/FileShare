//
//  PDFDocument.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/1.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface PDFDocument : File

@property (nonatomic, assign, readonly) NSUInteger numberOfPages;
@property (nonatomic, strong, readonly) UIImage *thumbnailImage;
@property (nonatomic, assign, readonly) CGPDFDocumentRef CGPDFDocument;
@property (nonatomic, copy, readonly) NSString *title;

@property(nonatomic,  assign,  readonly)NSUInteger currentPage;

@end
