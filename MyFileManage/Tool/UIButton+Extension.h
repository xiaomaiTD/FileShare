//
//  UIButton+Extension.h
//  MyFileManage
//
//  Created by Viterbi on 2018/2/6.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^targetBlcok)(UIButton * sender);

@interface UIButton (Extension)
@property(nonatomic,copy)targetBlcok executeBlock;
-(void)addTargetWithBlock:(targetBlcok)block;
@end
