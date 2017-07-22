//
//  ReaderPDFViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/31.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ReaderPDFViewController.h"
#import "PDFPageViewController.h"
#import "PDFDocument.h"
#import "MenuAndNavBarView.h"



@interface ReaderPDFViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>


@property(nonatomic,strong)UIPageViewController *pageVC;

@end

@implementation ReaderPDFViewController

-(void)viewWillAppear:(BOOL)animated{

    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _document = [[PDFDocument alloc] initWithPath:_pdfPath];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(24)}];
    
    PDFPageViewController *firstVc = [self pageViewControllerAtIndex:1];
    
    firstVc.view.backgroundColor = [UIColor whiteColor];
    
    [self.pageVC setViewControllers:@[firstVc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    
    self.pageVC.delegate = self;
    
    self.pageVC.dataSource = self;
    
    [self addChildViewController:self.pageVC];
 
    [self.view addSubview:self.pageVC.view];
    
  
    self.pageVC.view.frame = self.view.bounds;
    
    

    [self.view addGestureRecognizer:({
        
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelected)];
        
        tap;
        
        
    })];
    
    
    
}

-(void)cancelSelected{




    [MenuAndNavBarView MenuAndNavBarShowOrHidden];


}





- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.document.currentPage == 1) {
        return nil;
    }
    
    return [self pageViewControllerAtIndex:self.document.currentPage - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self pageViewControllerAtIndex:self.document.currentPage + 1];
}


- (PDFPageViewController *)pageViewControllerAtIndex:(NSUInteger)index
{
    PDFPage *page = [self.document pageAtIndex:index];
    if (!page) {
        
        return nil;
        
    }
    PDFPageViewController *vc =
    [[PDFPageViewController alloc] initWithPage:page];
    
    
    return vc;
}

-(void)dealloc{
    
    
    NSLog(@"dealloc");
    
}




@end
