//
//  spliteView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/20.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "spliteView.h"
#import "NSString+CHChinese.h"


@interface spliteView()

@property(nonatomic,strong)NSMutableArray *spliteStrArray;

@property(nonatomic,strong)NSMutableArray *spliteStrBtnArray;

@end

@implementation spliteView


-(instancetype)initWithFrame:(CGRect)frame{


    if (self = [super initWithFrame:frame]) {
        _spliteStrArray = [[NSMutableArray alloc] initWithCapacity:0];
        _spliteStrBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}


-(void)layoutSubviews{
    
    _beSpliteString = [_beSpliteString ch_substringWithChinese:CHNSStringChineseTypeCharacter inRange:NSMakeRange(0, _beSpliteString.length)];
    [_beSpliteString enumerateSubstringsInRange:NSMakeRange(0, _beSpliteString.length) options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {

        [self.spliteStrArray addObject:substring];
        
    }];
    
    [self spliteStrForBtn];

}

-(void)spliteStrForBtn{

    [self.spliteStrArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGFloat btnW = [self getWidthWithText:obj font:13 height:20].width;
        
        btnW = btnW >= 20 ? btnW:30;
        
        if (idx == 0) {
            
            UIButton *btn = [self createBtnWithTitle:obj];
            
            btn.frame = CGRectMake(8, 0, btnW + 5, 20);
            
            [self.spliteStrBtnArray addObject:btn];
            
            [self addSubview:btn];
        }
        else{
    
            UIButton *lastBtn = self.spliteStrBtnArray.lastObject;
            UIButton *currentBtn = [self createBtnWithTitle:obj];
            currentBtn.frame = CGRectMake(lastBtn.maxX + 8,lastBtn.y, btnW + 5, 20);
           // 说明超出屏幕外面了
            if (currentBtn.maxX > self.width - 8) {
                currentBtn.x  = 8;
                currentBtn.y = lastBtn.maxY + 8;
            }

            [self.spliteStrBtnArray addObject:currentBtn];
            [self addSubview:currentBtn];
        }
    }];
    
    
    
    for (UIButton *btn in self.spliteStrBtnArray) {
        
        btn.y = btn.y + self.height;
    }
    
    
    for (int i = 0; i<self.spliteStrBtnArray.count; i++) {
        
        UIButton *btn = self.spliteStrBtnArray[i];
        [UIView animateWithDuration:0.2 delay:i*0.05 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            btn.y  =btn.y - self.height;
                
        } completion:nil];
        
    }
    

}



-(UIButton *)createBtnWithTitle:(NSString *)title{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 5;
    
    btn.layer.masksToBounds = YES;
    
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    
    return btn;

}

@end
