//
//  SettingNotifyTableCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/31.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SettingNotifyTableCell.h"
#import "GloablVarManager.h"

@interface SettingNotifyTableCell()

@property(nonatomic,strong)UISwitch *switchON;

@end

@implementation SettingNotifyTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.switchON = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self.switchON addTarget:self action:@selector(switchON:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.switchON];
        
        [self.switchON mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-40);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return self;
}

-(void)switchON:(UISwitch *)switchON{
    
    [[GloablVarManager shareManager] setShowHiddenFolder:YES];

}

@end
