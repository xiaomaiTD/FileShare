//
//  SettingRecycelCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/3.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SettingRecycelCell.h"

@implementation SettingRecycelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModel:(fileModel *)model{
    _model = model;
    self.textLabel.text = model.fileName;
    if (model.isFolder) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
