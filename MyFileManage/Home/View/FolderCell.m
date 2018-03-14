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
        
        self.maskView = [[maskLocalView alloc] initWithFrame:CGRectZero];
        self.maskView.hidden = YES;
        [self addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 1;
        [self addGestureRecognizer:longPress];
        
    }
    return self;
}

-(void)longPress:(UILongPressGestureRecognizer *)logPress{
    if (logPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(folderCellLongPressWithModel:)]) {
            [self.delegate folderCellLongPressWithModel:self.model];
        }
    }
}

-(void)setModel:(fileModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.textView.text = _model.fileName;
}

@end
