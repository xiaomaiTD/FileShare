//
//  SelectedFolderCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/15.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SelectedFolderCell.h"

@interface SelectedFolderCell()

@property(nonatomic,strong)UIImageView *selectedImageV;
@property(nonatomic,strong)UIView *maskView;

@end

@implementation SelectedFolderCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.textView.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
        self.maskView.backgroundColor = [[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.3];
        [self addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UIImageView *imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        imagV.hidden = YES;
        _selectedImageV = imagV;
        [self addSubview:imagV];
        [imagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        
    }
    return self;
    
}
-(void)setModel:(fileModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.textView.text = _model.fileName;
    _selectedImageV.hidden = !_model.selected;
}



@end
