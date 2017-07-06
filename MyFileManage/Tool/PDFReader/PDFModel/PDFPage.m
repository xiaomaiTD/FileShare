//
//  PDFPage.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/1.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFPage.h"

@interface PDFPage()


@property (nonatomic ,assign)CGRect pageRect;

@end

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

- (void)drawInRect:(CGRect)rect inContext:(CGContextRef)context cropping:(BOOL)cropping
{
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillRect(context, CGContextGetClipBoundingBox(context));
    
    CGContextTranslateCTM(context, 0.0f, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGRect pdfRect = self.rect;
    CGRect drawRect = cropping ? self.croppedRect : pdfRect;
    CGFloat scale = rect.size.width / drawRect.size.width;
    CGContextScaleCTM(context, scale, scale);
    CGContextTranslateCTM(context,
                          -drawRect.origin.x,
                          -(pdfRect.size.height - CGRectGetMaxY(drawRect)));
    
    CGContextDrawPDFPage(context, self.CGPDFPage);
    
}

- (UIImage *)thumbnailImageWithSize:(CGSize)size cropping:(BOOL)cropping
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)
           inContext:context
            cropping:cropping];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(CGRect)croppedRect{


    CGRect rect = self.rect;
    
    return rect;


}


@end
