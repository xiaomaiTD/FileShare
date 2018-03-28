//
//  SettingHistoryCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/28.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SettingHistoryCell.h"

@implementation SettingHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

-(void)setModel:(fileModel *)model{
    _model = model;
    self.textLabel.text = _model.name;
}

@end
