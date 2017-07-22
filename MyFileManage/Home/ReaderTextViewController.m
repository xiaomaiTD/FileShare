//
//  ReadTextViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/4.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ReaderTextViewController.h"
#import "ReadTXTPageViewController.h"

#import "sentenSpliteViewController.h"

#import "MenuAndNavBarView.h"





@interface ReaderTextViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic,strong)UIPageViewController *pageVC;

@end

@implementation ReaderTextViewController

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(24)}];
    
    ReadTXTPageViewController *firstVc = [self pageViewControllerAtIndex:0];
    
   
    [self.view addGestureRecognizer:({
        
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelected)];
        
        tap;
        
        
    })];

    
    [self.pageVC setViewControllers:@[firstVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageVC.delegate = self;
    
    self.pageVC.dataSource = self;
    
    [self addChildViewController:self.pageVC];
    
    [self.view addSubview:self.pageVC.view];
    
    
    self.pageVC.view.frame = self.view.bounds;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSpliteStr:) name:SPLITECONTENTNOTIFY object:nil];


    
    

}
-(void)cancelSelected{
    
    
    [MenuAndNavBarView MenuAndNavBarShowOrHidden];
    


    [_pageVC.viewControllers enumerateObjectsUsingBlock:^(__kindof ReadTXTPageViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        
        [obj.textView cancelSelected];
        
        
    }];
    
    
    
}



-(void)getSpliteStr:(NSNotification *)notify{
    
    
    NSString *content = notify.userInfo[@"contentString"];
    
    
    sentenSpliteViewController *vc= [[sentenSpliteViewController alloc] init];
    
    vc.contentString = content;
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
    
}



-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{

    
    if (_model.currentPage == 0) {
        return nil;
    }
    
    
    
    return [self pageViewControllerAtIndex:_model.currentPage-1];

}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{

    return [self pageViewControllerAtIndex:_model.currentPage + 1];
    

    
}

-(ReadTXTPageViewController *)pageViewControllerAtIndex:(NSInteger)index{

    
    NSString *content = [_model stringOfPage:index];
    
    if (!content) {
        
        return nil;
    }

    ReadTXTPageViewController *vc = [[ReadTXTPageViewController alloc] init];
    vc.content = content;

    
    return vc;


}

-(void)dealloc{


    NSLog(@"dealloc");

}


@end
