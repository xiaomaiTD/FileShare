//
//  HomeToolBarView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/15.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "HomeToolBarView.h"

@implementation HomeToolBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectZero];
        lineLable.backgroundColor = [UIColor lightGrayColor];
        lineLable.alpha = 0.5;
        [self addSubview:lineLable];
        [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.and.right.mas_offset(0);
            make.size.height.mas_offset(1);
        }];
        
        NSInteger offset = 10;
        UIButton *tempBtn = nil;
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
            [self addSubview:btn];
            if (i == 0) {
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(offset);
                    make.top.equalTo(lineLable.mas_bottom).mas_offset(1);
                    make.bottom.equalTo(self);
                }];
            }else if (i == 4){
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_offset(-offset);
                    make.top.equalTo(lineLable.mas_bottom).mas_offset(1);
                    make.bottom.equalTo(self);
                    make.left.equalTo(tempBtn.mas_right).mas_offset(offset);
                    make.width.equalTo(tempBtn);
                }];
                
            }else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(tempBtn.mas_right).mas_offset(offset);
                    make.top.equalTo(lineLable.mas_bottom).mas_offset(1);
                    make.bottom.equalTo(self);
                    make.width.equalTo(tempBtn);
                }];
            }
            
            tempBtn = btn;
        }
    }
    return self;
}

-(void)setUI{
  
  
}

@end
