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
    [super setModel:model];
    if (self.model != model) {
        self.model = model;
    }
    _selectedImageV.hidden = !self.model.selected;
}



@end
