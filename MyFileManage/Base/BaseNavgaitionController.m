//
//  BaseNavgaitionController.m
//  POSystem
//
//  Created by 掌上先机 on 17/1/13.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "BaseNavgaitionController.h"

@interface BaseNavgaitionController ()

@end

@implementation BaseNavgaitionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-20, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES];
    self.interactivePopGestureRecognizer.enabled = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat kScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnW = kScreenW > 375.0 ? 50:40;
    backBtn.frame = CGRectMake(0, 0, btnW, 40);
    _backItem = backBtn;
}

-(void)backClick:(UIButton *)sender{
    [self popViewControllerAnimated:YES];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backItem];
    }
    [super pushViewController:viewController animated:animated];
}


@end
