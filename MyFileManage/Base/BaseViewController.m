//
//  BaseViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/13.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD+Vi.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

-(void)showMessageWithTitle:(NSString *)title{
    [MBProgressHUD showMessage:title];
}

-(void)showMessage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hidenMessage{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)showSuccessWithTitle:(NSString *)title{
    
    [MBProgressHUD showSuccess:title];
}

-(void)showSuccess{
    [MBProgressHUD showSuccess:@"success!"];
}

-(void)showErrorWithTitle:(NSString *)title{
    [MBProgressHUD showError:title];
}

-(void)showError{
    [self showErrorWithTitle:@"error"];
}

-(void)dealloc{
    NSLog(@"class is dealloc  %@",[self classForCoder]);
}

@end

