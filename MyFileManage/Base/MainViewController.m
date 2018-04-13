//
//  MainViewController.m
//  LotteryProject
//
//  Created by wangchao on 2017/4/3.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavgaitionController.h"
#import "HomeFolderViewController.h"
#import "SettingViewController.h"
#import "connectionViewController.h"
#import "BrowerLocalViewController.h"
#import "SMBViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tabBar setTintColor:MAINCOLOR];
    [self addChildViewControllers];
    
}

- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]];
    childVc.tabBarItem.selectedImage = selectedImage;
    BaseNavgaitionController *nav = [[BaseNavgaitionController alloc] initWithRootViewController:childVc];
        [self addChildViewController:nav];
}
//添加字控制器
-(void)addChildViewControllers{
    
    [self addOneChlildVc:[HomeFolderViewController new] title:@"首页" imageName:@"home"];
    [self addOneChlildVc:[connectionViewController new] title:@"快传" imageName:@"wifi"];
    [self addOneChlildVc:[SMBViewController new] title:@"网络" imageName:@"connect"];
    [self addOneChlildVc:[BrowerLocalViewController new] title:@"本地" imageName:@"local"];
    [self addOneChlildVc:[SettingViewController new] title:@"设置" imageName:@"setting"];
    
}

@end
