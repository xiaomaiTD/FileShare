//
//  EasyAlertView.h
//  MyFileManage
//
//  Created by Viterbi on 2018/3/29.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AlertViewSheet,
    AlertViewAlert
} AlertViewPopType;

typedef void(^actionBlock)(NSString *title,NSInteger index,NSArray *textFieldArray);

@interface EasyAlertView : NSObject

-(instancetype)initWithType:(AlertViewPopType)type andTitle:(NSString *)title andActionArray:(NSArray *)array andActionBlock:(actionBlock)block;


//弹出的样式
@property(nonatomic,assign)AlertViewPopType type;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSArray *textFieldArray;
/*
 typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
 UIAlertActionStyleDefault = 0,
 UIAlertActionStyleCancel,
 UIAlertActionStyleDestructive
 }
 */

/**
 传入点击按钮的字典,0->UIAlertActionStyleDefault,1->UIAlertActionStyleCancel,2->UIAlertActionStyleDestructive
 */
@property(nonatomic,strong)NSArray<NSDictionary<NSString *,NSNumber *> *> *actionArray;
@property(nonatomic,strong)actionBlock block;

-(void)addTextFieldWithBlock:(void(^)(UITextField *textField))block;
-(void)showInViewController:(UIViewController *)controller;

@end
