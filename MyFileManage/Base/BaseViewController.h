//
//  BaseViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/13.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileModel.h"

@interface BaseViewController : UIViewController

@property(nonatomic,strong)fileModel *model;

-(void)showMessage;
-(void)hidenMessage;

-(void)showMessageWithTitle:(NSString *)title;

-(void)showErrorWithTitle:(NSString *)title;
-(void)showSuccessWithTitle:(NSString *)title;
-(void)showSuccess;
-(void)showError;
@end

