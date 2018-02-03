//
//  RecyleFileViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/3.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "RecyleFileViewController.h"
#import "ResourceFileManager.h"
#import "SettingRecycelCell.h"
#import "fileModel.h"

@interface RecyleFileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray<fileModel *> *dataArray;

@end

@implementation RecyleFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SettingRecycelCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.dataArray = [[ResourceFileManager shareInstance] getAllRecycelFolderFileModels];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingRecycelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        fileModel *model = self.dataArray[indexPath.row];
//        cell.textLabel.text = model.fileName;
        cell.model = model;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

@end
