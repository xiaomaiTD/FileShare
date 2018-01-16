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
    // Do any additional setup after loading the view.
}

-(void)showMessageWithTitle:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = title;
}

-(void)showMessage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hidenMessage{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)showSuccess{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"success!";
    // Move to bottm center.
    [hud hide:YES afterDelay:3];
    
}
-(void)showError{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    
    // Move to bottm center.
    hud.labelText = @"error";
    [hud hide:YES afterDelay:3];
}

-(void)dealloc{
    NSLog(@"class is dealloc  %@",[self classForCoder]);
}

@end

