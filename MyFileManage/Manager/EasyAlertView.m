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

-(instancetype)initWithType:(AlertViewPopType)type andActionArray:(NSArray *)array andActionBloc:(actionBlock)block{
    if (self = [super init]) {
        self.type = type;
        self.actionArray = array;
        self.block = block;
        [self configueUI];
    }
    return self;
}

-(instancetype)init{
    
    if (self = [super init]) {
        self.type = AlertViewAlert;
        [self configueUI];
    }
    return self;
}


-(void)configueUI{
    
    if (self.actionArray == NULL || self.actionArray.count == 0) {
        return;
    }
    
}



-(void)showInViewController:(UIViewController *)controller{
    
    [controller presentViewController:self.alertController animated:YES completion:nil];
}

-(void)setType:(AlertViewPopType)type{
    _type = type;
}

-(void)setBlock:(actionBlock)block{
    _block = block;
}
@end
