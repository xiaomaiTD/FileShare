//
//  sentenSpliteViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/20.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "sentenSpliteViewController.h"

#import "spliteView.h"


@interface sentenSpliteViewController ()

@end

@implementation sentenSpliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.view.layer.cornerRadius = 8;
    self.view.layer.masksToBounds = YES;
    
    
    
    spliteView *sv = [[spliteView alloc] initWithFrame:CGRectMake(0, 16, self.view.width, self.view.height - 16)];
    
    sv.beSpliteString = self.contentString;
    
    
    [self.view addSubview:sv];
    
    
    
    UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
    
    dele.frame = CGRectMake(0, 0, 40, 40);
    
    dele.centerX = self.view.width/2.0;
    
    
    dele.y = self.view.height - 80;
    
    [dele addTarget:self action:@selector(deleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    dele.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:dele];
    
    
    
    
    
    // Do any additional setup after loading the view.
}

-(void)deleClick:(UIButton *)sender{


    [self dismissViewControllerAnimated:YES completion:nil];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
