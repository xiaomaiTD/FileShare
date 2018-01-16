//
//  MenuAndNavBarView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/22.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "MenuAndNavBarView.h"
#import "MainViewController.h"

@interface MenuAndNavBarView()

@end

@implementation MenuAndNavBarView

static MenuAndNavBarView *menAndNaView;

+(void)MenuAndNavBarShowOrHidden{

    [self shareInstance];
    
    [UIView animateWithDuration:0.2 animations:^{
       
        menAndNaView.y = menAndNaView.y < 0 ? 0:-64;
        
    }];

}


+(instancetype)shareInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        menAndNaView = [[MenuAndNavBarView alloc] initWithFrame:CGRectMake(0, -64, [UIApplication sharedApplication].keyWindow.bounds.size.width, 64)];
        
        menAndNaView.backgroundColor = RGB(249, 249, 249);
        
        [[UIApplication sharedApplication].keyWindow addSubview:menAndNaView];;
        
    });

    return menAndNaView;



}

-(instancetype)initWithFrame:(CGRect)frame{



    if (self = [super initWithFrame:frame]) {
        
        UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        lineLable.backgroundColor = RGB(217, 216, 217);
        [self addSubview:lineLable];
        

        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.bounds = CGRectMake(0, 0, 30, 30);
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        backBtn.centerY = 40;
        [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.centerX = 32;
        [self addSubview:backBtn];
        
    }

    return self;


}

-(void)backClick:(UIButton *)sender{

    [UIView animateWithDuration:0.2 animations:^{
        
        menAndNaView.y = -64;
        
        
    } completion:^(BOOL finished) {
       
        MainViewController *tabbar = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        UINavigationController *nav = (UINavigationController *)[tabbar childViewControllers].firstObject;
        
        [nav popViewControllerAnimated:YES];

        
    }];
    

    

}

@end
