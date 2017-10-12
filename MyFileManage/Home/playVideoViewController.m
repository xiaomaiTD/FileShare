//
//  playVideoViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "playVideoViewController.h"
#import "playView.h"
#import "progressView.h"
#import "Masonry.h"

@interface playVideoViewController ()

@property (strong, nonatomic)playView *myPlayView;

@property(assign,nonatomic)BOOL isHalfScreen;


@end

@implementation playVideoViewController

-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES animated:YES];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myPlayView = [[playView alloc] initWithFrameAndUrl:CGRectMake(0, 0, kScreenWidth, kScreenHeight-300) url:_model.fullPath];

    [self.view addSubview:_myPlayView];
    progressView * view = _myPlayView.playProgress;
    
    [view.screenFullButton addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)fullScreenBtnClick:(UIButton *)sender{

    if ([sender.currentTitle isEqualToString:@"全屏"]) {
    
        [UIView animateWithDuration:0.5 animations:^{
            self.myPlayView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
            self.myPlayView.center = self.view.center;
            CGAffineTransform form = CGAffineTransformIdentity;
            self.myPlayView.transform = CGAffineTransformRotate(form, M_PI_2);
            
        } completion:^(BOOL finished) {
            [sender setTitle:@"小屏" forState:UIControlStateNormal];
        }];
    }
    else{

        [UIView animateWithDuration:0.5 animations:^{
            
            CGAffineTransform form = CGAffineTransformIdentity;
            
            self.myPlayView.transform = CGAffineTransformRotate(form, 0);
            
            self.myPlayView.frame = CGRectMake(0, 0, kScreenWidth , kScreenHeight - 300);
            
        } completion:^(BOOL finished) {
            
            [sender setTitle:@"全屏" forState:UIControlStateNormal];
            
        }];

    }
 
    
}

-(void)dealloc{
    
    NSLog(@"dealloc");
    
}




@end
