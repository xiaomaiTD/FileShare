//
//  RecyleFileViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/3.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import "UIViewController+Extension.h"
#import "RecyleFileViewController.h"
#import "ResourceFileManager.h"
#import "FMDBTool.h"
#import "EasyAlertView.h"
#import "FolderFileManager.h"
#import "SettingRecycelCell.h"
#import "fileModel.h"

@interface RecyleFileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray<fileModel *> *dataArray;

@end

@implementation RecyleFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的回收站";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SettingRecycelCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.dataArray = [[ResourceFileManager shareInstance] getAllRecycelFolderFileModels].mutableCopy;
    [self.tableView reloadData];
    
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
    
    BOOL hasAllDelete = NO;
    
    hasAllDelete = [[FolderFileManager shareInstance] deleteContentFileInDic:[[FolderFileManager shareInstance] getCycleFolderPath]];
    if (hasAllDelete) {
        [self showSuccessWithTitle:@"删除成功"];
        [self.dataArray removeAllObjects];
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self showErrorWithTitle:@"删除失败"];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingRecycelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        fileModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        fileModel *model = self.dataArray[indexPath.row];
        [[FMDBTool shareInstance] deleteHistoryModel:model];
        [self.dataArray removeObject:model];
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return @[deleteAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fileModel *model = self.dataArray[indexPath.row];
    
    NSArray *actionArray = @[@{@"删除不可回收":@(2)},@{@"恢复至主界面":@(0)},@{@"取消":@(1)}];
    
    EasyAlertView *alert = [[EasyAlertView alloc] initWithType:AlertViewSheet andTitle:model.name andActionArray:actionArray andActionBloc:^(NSString *title,NSInteger index) {
        if ([title isEqualToString:@"删除不可回收"]) {
            
            [[FolderFileManager shareInstance] deleteFileInPath:model.fullPath];
            [self.dataArray removeObject:model];
            NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];

        }else if ([title isEqualToString:@"恢复至主界面"]){
            [self moveToHomeModel:model];
        }else{
            
        }
    }];
    [alert showInViewController:self];
    
}

-(void)moveToHomeModel:(fileModel *)model{
    
    [[FolderFileManager shareInstance] moveFileFromPath:model.fullPath toDestionPath:[[FolderFileManager shareInstance] getUploadPath]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FileFinish" object:nil];
    [self.dataArray removeObject:model];
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];

    [self showSuccess];
    
}

@end
