//
//  PDFPageViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/2.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFPageViewController.h"
#import "PDFContentView.h"


@interface PDFPageViewController ()


@property (nonatomic, strong, readwrite) PDFPage *page;

@property(nonatomic,strong)UIImageView *pdfImgV;//显示pdf，主要是通过pdf产生图片显示在界面上

@end

@implementation PDFPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
   

    PDFContentView *pageView = [[PDFContentView alloc] initWithPage:_page];
    
    CGFloat pageViewH = self.view.width /  _page.rect.size.width * _page.rect.size.height;
    
    
    pageView.frame = CGRectMake(0, 0, self.view.width, pageViewH);
    
    pageView.center = self.view.center;
    
    
    [self.view addSubview:pageView];
    
    
    
}

-(instancetype)initWithPage:(PDFPage *)page{

    if (self = [super init]) {
        
        _page = page;
        
    }
    return self;

}

-(void)loadView{


    UIScrollView *padfScr = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    padfScr.minimumZoomScale = 1.0;
    
    padfScr.maximumZoomScale = 4.0;
    
    self.view = padfScr;
    
}



@end
