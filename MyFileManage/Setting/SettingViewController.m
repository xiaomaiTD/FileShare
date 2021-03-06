//
//  SettingViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "SettingViewController.h"
#import "HistoryViewController.h"
#import "SettingBaseTableCell.h"
#import "SettingNotifyTableCell.h"
#import "RecyleFileViewController.h"
#import "CollectionViewController.h"
#import "MoveFolderViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <DMPasscode/DMPasscode.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    NSString *touchIDDes = [[DataBaseTool shareInstance] haveOpenTouchID] ? @"关闭touchID":@"开启touchID";
    NSArray *dataArr = @[@[touchIDDes],@[@"我的收藏"],@[@"回收站",@"历史访问记录"],@[@"下载至下载目录",@"下载至自定义目录"],@[@"显示文件扩展",@"显示隐藏的文件夹"],@[@"给个好评",@"意见反馈"]];
    self.dataArray = [[NSMutableArray alloc] initWithArray:dataArr];
    self.imageArray = @[@[@"指纹"],@[@"收藏"],@[@"回收站",@"历史记录"],@[@"下载",@"自定义路径"],@[@"显示文件",@"显示"],@[@"好评",@"反馈"]];
    
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
    
    SettingBaseTableCell *cell;
    if (indexPath.section == 4) {
        cell = (SettingNotifyTableCell *)[tableView dequeueReusableCellWithIdentifier:@"NotifyTableCell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTableCell" forIndexPath:indexPath];
    }
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
    cell.indexPath = indexPath;
    return cell;
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
    if (indexPath.section == 1) {
        CollectionViewController *collection = [[CollectionViewController alloc] init];
        APPNavPushViewController(collection);
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            RecyleFileViewController *vc = [[RecyleFileViewController alloc] init];
            APPNavPushViewController(vc);
        }
        if (indexPath.row == 1) {
            HistoryViewController *vc = [[HistoryViewController alloc] init];
            APPNavPushViewController(vc);
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 1) {
            MoveFolderViewController *vc = [[MoveFolderViewController alloc] init];
            vc.isSelectedDowload = YES;
            APPNavPushViewController(vc);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)showPasswordVC{
    
    if (![DMPasscode isPasscodeSet] && ![[DataBaseTool shareInstance] haveOpenTouchID]) {
        [DMPasscode setupPasscodeInViewController:self completion:^(BOOL success, NSError *error) {
            if (success) {
                [[DataBaseTool shareInstance] setTouchIDFlage:1];
                NSArray *array = @[@"关闭touchID"];
                [self.dataArray replaceObjectAtIndex:0 withObject:array];
                [self.tableView reloadData];
            }
        }];
    }
}

@end
