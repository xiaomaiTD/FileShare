//
//  CollectionViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/23.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "CollectionViewController.h"
#import "SettingCollectionCell.h"
#import "FolderFileManager.h"
#import "FMDBTool.h"

@interface CollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的收藏";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SettingCollectionCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [[FMDBTool shareInstance] selectedCollectionModel:^(NSArray *data) {
        self.dataArray = data.mutableCopy;
        [self.tableView reloadData];
    }];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        fileModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        fileModel *model = _dataArray[indexPath.row];
        if ([[FolderFileManager shareInstance] judgePathIsExits:model.fullPath]) {
            [self openVCWithModel:model];
        }else{
            [self showErrorWithTitle:@"改文件不存在"];
            [self.dataArray removeObject:model];
            NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        fileModel *model = self.dataArray[indexPath.row];
        [[FMDBTool shareInstance] deleteCollectionModel:model];
        [self.dataArray removeObject:model];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return @[deleteAction];
}



@end
