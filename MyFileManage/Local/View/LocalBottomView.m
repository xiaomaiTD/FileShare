//
//  LocalBottomView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/5.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "LocalBottomView.h"

@implementation LocalBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [self addSubview:self.sendBtn];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.bottom.mas_equalTo(0);
        }];
        
        
        
    }
    return self;
}
@end
