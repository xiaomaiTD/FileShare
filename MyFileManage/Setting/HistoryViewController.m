//
//  HistoryViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/27.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import "UIViewController+Extension.h"
#import "HistoryViewController.h"
#import "SettingHistoryCell.h"
#import "FolderFileManager.h"
#import "EasyAlertView.h"
#import "FMDBTool.h"
#import "fileModel.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray<fileModel *> *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation HistoryViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史访问记录";
    [self.tableView registerClass:[SettingHistoryCell class] forCellReuseIdentifier:@"SettingHistoryCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [[FMDBTool shareInstance] selectedAllHistoryModel:^(NSArray *data) {
        self.dataArray = data.mutableCopy;
        [self.tableView reloadData];
    }];
    @weakify(self);
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        if (self.dataArray.count == 0) {
            return;
        }
        NSArray *actionArray = @[@{@"确定":@(0)},@{@"取消":@(0)}];
        EasyAlertView *alert = [[EasyAlertView alloc] initWithType:AlertViewAlert andTitle:@"是否清空数据" andActionArray:actionArray andActionBloc:^(NSString *title,NSInteger index) {
            if (index == 0) {
                [self clearData];
            }
        }];
        [alert showInViewController:self];
    }];
    [self addRigthItemWithCustomView:deleteBtn];
}

-(void)clearData{
    [self showMessageWithTitle:@"正在清除.."];
    [[FMDBTool shareInstance] deleteAllHistoryModel:^(BOOL success) {
        [self hidenMessage];
        if (success) {
            [self showSuccess];
            [self.dataArray removeAllObjects];
            NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self showError];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingHistoryCell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        fileModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fileModel *model = self.dataArray[indexPath.row];
    if ([[FolderFileManager shareInstance] judgePathIsExits:model.fullPath]) {
        [self openVCWithModel:model];
    }else{
        [self showErrorWithTitle:@"此文件已经被移动了"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
