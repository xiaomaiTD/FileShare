//
//  SettingViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingBaseTableCell.h"
#import "SettingNotifyTableCell.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <DMPasscode/DMPasscode.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    _dataArray = @[@[@"开启touchID"],@[@"我的收藏"],@[@"回收站",@"历史访问记录"],@[@"下载目录",@"自定义目录"],@[@"显示文件扩展",@"显示隐藏的文件"],@[@"给个好评",@"意见反馈"]];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUI];
}
-(void)setUI{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView registerClass:[SettingNotifyTableCell class] forCellReuseIdentifier:@"NotifyTableCell"];
    [self.tableView registerClass:[SettingBaseTableCell class] forCellReuseIdentifier:@"BaseTableCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 4) {
        SettingNotifyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyTableCell" forIndexPath:indexPath];
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else{
        SettingBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableCell" forIndexPath:indexPath];
        cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [GCDQueue executeInMainQueue:^{
           [self showPasswordVC];
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)showPasswordVC{

    [DMPasscode showPasscodeInViewController:self completion:^(BOOL success, NSError *error) {
        NSLog(@"success");
    }];
}

@end
