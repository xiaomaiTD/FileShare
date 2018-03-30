//
//  EasyAlertView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/29.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "EasyAlertView.h"

@interface EasyAlertView()

@property(nonatomic,strong)UIAlertController *alertController;

@end

@implementation EasyAlertView

-(instancetype)initWithType:(AlertViewPopType)type andTitle:(NSString *)title andActionArray:(NSArray *)array andActionBloc:(actionBlock)block{
    
    if (self = [super init]) {
        _type = type;
        _title = title;
        _actionArray = array;
        _block = [block copy];
        [self configueUI];
    }
    return self;
    
}

-(void)configueUI{
    
    if (self.actionArray == NULL || self.actionArray.count == 0) {
        return;
    }
    
    self.alertController = [UIAlertController alertControllerWithTitle:self.title message:nil preferredStyle:(NSInteger)self.type];

    for (NSDictionary *dic in self.actionArray) {
        NSInteger index = [self.actionArray indexOfObject:dic];
        NSString *message = dic.allKeys.firstObject;
        NSNumber *number = dic[message];
        UIAlertAction *action = [UIAlertAction actionWithTitle:message style:[number integerValue] handler:^(UIAlertAction * _Nonnull action) {
            if (self.block) {
                self.block(action.title, index);
                self.alertController = nil;
            }
        }];
        
        [self.alertController addAction:action];
    }
}

-(void)showInViewController:(UIViewController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
      [controller presentViewController:self.alertController animated:YES completion:nil];
    });
}

-(void)setType:(AlertViewPopType)type{
    _type = type;
}

-(void)setBlock:(actionBlock)block{
    _block = block;
}

-(void)dealloc{
    NSLog(@"EasyAlertView dealloc");
}

@end
