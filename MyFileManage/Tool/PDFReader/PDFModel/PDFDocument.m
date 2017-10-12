//
//  PDFDocument.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/1.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFDocument.h"
#import "PDFPage.h"



@interface PDFDocument()

@property (nonatomic, assign, readwrite) NSUInteger numberOfPages;
@property (nonatomic, strong, readwrite) UIImage *thumbnailImage;
@property (nonatomic, assign, readwrite) CGPDFDocumentRef CGPDFDocument;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) NSUInteger currentPage;

@end

@implementation PDFDocument

-(instancetype)initWithPath:(NSString *)path{


    if (self = [super initWithPath:path]) {
        
        NSURL *URL = [NSURL fileURLWithPath:path];
        _CGPDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)URL);
        if (_CGPDFDocument) {
            _numberOfPages = CGPDFDocumentGetNumberOfPages(_CGPDFDocument);
        } else {
            self.fileNotExist = YES;
            return self;
        }
         _currentPage = 1;
        [self loadThumbnailImageAsync];
        
    }

    return self;

}

- (void)loadThumbnailImageAsync
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        UIImage *image = [self loadThumbnailImage] ?: [self makeThumbnailImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnailImage = image;
            self.iconImage = image;
        });
    });
}

- (UIImage *)makeThumbnailImage
{
    PDFPage *page = [self pageAtIndex:1];
    CGFloat width = IsPad() ? 180 : 100;
    
    CGRect pageRect = page.rect;
    CGFloat ratio = pageRect.size.height / pageRect.size.width;
    CGFloat w, h;
    if (pageRect.size.width > pageRect.size.height) {
        w = width; h = width * ratio;
    } else {
        w = width / ratio; h = width;
    }
    
    CGRect rect = CGRectMake(0, 0, w, h);
    CGFloat scale = UIScreen.mainScreen.scale;
    UIGraphicsBeginImageContextWithOptions(rect.size,
                                           NO,
                                           scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIColor.whiteColor set];
    UIRectFill(CGRectMake(0, 0, w, h));
    
    CGContextSaveGState(context);
    {
        CGContextTranslateCTM(context, 0.0f, rect.size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextConcatCTM(context,
                           CGPDFPageGetDrawingTransform(page.CGPDFPage,
                                                        kCGPDFMediaBox,
                                                        CGRectMake(0, 0, w, h),
                                                        0,
                                                        YES));
        CGContextSetInterpolationQuality(context ,kCGInterpolationHigh);
        CGContextDrawPDFPage(context, page.CGPDFPage);
    } CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self writeThumbnailImageAsync:image];
    
    return image;
}

- (void)writeThumbnailImageAsync:(UIImage *)image
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [UIImagePNGRepresentation(image) writeToFile:self.imagePath
                                          atomically:YES];
    });
}


- (UIImage *)loadThumbnailImage
{
    NSFileManager *fm = [NSFileManager new];
    NSString *path = self.imagePath;
    if ([fm fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        CGFloat scale = UIScreen.mainScreen.scale;
        return [UIImage imageWithData:data scale:scale];
    }
    return nil;
}

#pragma mark -

- (PDFPage *)pageAtIndex:(NSUInteger)index
{
    CGPDFPageRef cgPage = CGPDFDocumentGetPage(self.CGPDFDocument, index);
    if (cgPage) {
        
        PDFPage *page = [[PDFPage alloc] initWithCGPDFPage:cgPage];
        
        _currentPage = index;
   
        return page;
    } else {
        return nil;
    }
}

- (NSString *)imagePath
{
    return [NSString stringWithFormat:@"%@/PDFImageCache/%@",FileUploadSavePath,self.path.lastPathComponent];
}

-(NSString *)title
{
    if (_title == nil) {
        CGPDFDictionaryRef dict = CGPDFDocumentGetInfo(self.CGPDFDocument);
        CGPDFStringRef title = NULL;
        CGPDFDictionaryGetString(dict, "Title", &title);
        _title = (__bridge_transfer NSString *)CGPDFStringCopyTextString(title);
    }
    return _title;
}



@end
