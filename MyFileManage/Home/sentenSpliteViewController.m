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
    
    
    spliteView *sv = [[spliteView alloc] initWithFrame:self.view.bounds];
    
    sv.beSpliteString = self.contentString;
    
    
    [self.view addSubview:sv];
    
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
