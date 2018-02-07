//
//  UIButton+Extension.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/6.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

static void * UIButtonExecuteBlock;

@implementation UIButton (Extension)

-(void)addTargetWithBlock:(targetBlcok)block{
    self.executeBlock = block;
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton *)sender{
    if (!self.executeBlock) return;
    self.executeBlock(sender);
}

-(targetBlcok)executeBlock{
    return objc_getAssociatedObject(self, &UIButtonExecuteBlock);
}

-(void)setExecuteBlock:(targetBlcok)executeBlock{
    objc_setAssociatedObject(self, &UIButtonExecuteBlock, executeBlock, OBJC_ASSOCIATION_COPY);
}

@end
