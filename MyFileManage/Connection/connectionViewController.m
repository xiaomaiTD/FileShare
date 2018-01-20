//
//  connectionViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "connectionViewController.h"

@interface connectionViewController ()

@end

@implementation connectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"文件快传";
}

-(UIButton *)createBtnWithTitle:(NSString *)title{
    
    UIButton *filebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filebtn.backgroundColor = MAINCOLOR;
    [filebtn setTitle:title forState:UIControlStateNormal];
    [filebtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    filebtn.titleLabel.font = [UIFont systemFontOfSize:IsPhone() ? 13:15];
    return filebtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
