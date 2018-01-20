//
//  connectionViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "connectionViewController.h"
#import "senderViewController.h"
#import "receiveViewController.h"

@interface connectionViewController ()

@end

@implementation connectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"文件快传";
    UIButton *sender = [self createBtnWithTitle:@"我要发送"];
    [sender addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:sender];
    
    [sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *receive = [self createBtnWithTitle:@"我要接收"];
    [receive addTarget:self action:@selector(receiveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:receive];
    
    [receive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.top.equalTo(sender.mas_bottom).offset(60);
        make.height.mas_equalTo(50);
    }];
    
}

-(void)senderClick:(UIButton *)sender{
    
    senderViewController *vc = [[senderViewController alloc] init];
    APPNavPushViewController(vc);
}

-(void)receiveClick:(UIButton *)sender{
    receiveViewController *vc = [[receiveViewController alloc] init];
    APPNavPushViewController(vc);
}

-(UIButton *)createBtnWithTitle:(NSString *)title{
    
    UIButton *filebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filebtn.backgroundColor = MAINCOLOR;
    [filebtn setTitle:title forState:UIControlStateNormal];
    [filebtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    filebtn.titleLabel.font = [UIFont systemFontOfSize:IsPhone() ? 17:20];
    return filebtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
