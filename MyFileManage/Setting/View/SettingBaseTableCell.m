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
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.section == 3 && indexPath.row == 0) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
}

@end
