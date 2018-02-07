//
//  MoveFolderCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/7.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "MoveFolderCell.h"

@implementation MoveFolderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModel:(fileModel *)model{
    _model = model;
    self.textLabel.text = _model.fileName;
}

@end
