//
//  UIViewController+Extension.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/2.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

-(void)addRigthItemWithCustomView:(UIView *)custom{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:custom];
}

@end
