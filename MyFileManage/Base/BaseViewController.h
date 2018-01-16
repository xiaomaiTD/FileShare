//
//  BaseViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/13.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)showMessage;
-(void)hidenMessage;

-(void)showMessageWithTitle:(NSString *)title;
-(void)showSuccess;
-(void)showError;
@end

