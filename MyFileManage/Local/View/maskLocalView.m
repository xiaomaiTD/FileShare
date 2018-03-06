
//
//  maskLocalView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/6.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "maskLocalView.h"

@implementation maskLocalView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    UIImageView *imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
    [self addSubview:imagV];
    [imagV mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.offset(0);
      make.bottom.offset(0);
    }];
    
  }
  return self;
}

@end
