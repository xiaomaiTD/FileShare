//
//  HistoryViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/27.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "HistoryViewController.h"
#import "SettingHistoryCell.h"
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
    [self openVCWithModel:model];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

@end
