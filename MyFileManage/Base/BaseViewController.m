//
//  BaseViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/13.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

-(void)showMessageWithTitle:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = title;
}

-(void)showMessage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hidenMessage{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)showSuccessWithTitle:(NSString *)title{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"success!";
    // Move to bottm center.
    [hud hideAnimated:YES afterDelay:3];
}

-(void)showSuccess{
    [self showSuccessWithTitle:@"success"];
}

-(void)showErrorWithTitle:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    // Move to bottm center.
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:3];
}

-(void)showError{
    [self showErrorWithTitle:@"error"];
}

-(void)dealloc{
    NSLog(@"class is dealloc  %@",[self classForCoder]);
}

@end

