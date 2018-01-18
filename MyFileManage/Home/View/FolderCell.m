//
//  FolderCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FolderCell.h"


@implementation FolderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.textView.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

-(void)setModel:(fileModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.textView.text = _model.fileName;
}

@end
