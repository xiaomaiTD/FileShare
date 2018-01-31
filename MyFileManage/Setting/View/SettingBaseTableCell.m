//
//  SettingbaseTableCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/31.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SettingBaseTableCell.h"

@implementation SettingBaseTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType =  UITableViewCellAccessoryDetailDisclosureButton;
    }
    return self;
}

@end
