//
//  RecyleFileViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/3.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "RecyleFileViewController.h"
#import "ResourceFileManager.h"
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fileModel *model = self.dataArray[indexPath.row];
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:model.name message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *deleteAc = [UIAlertAction actionWithTitle:@"删除不可回收" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [[FolderFileManager shareInstance] deleteFileInPath:model.fullPath];
        [self.dataArray removeObject:model];
        
        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    [alertCon addAction:deleteAc];
    
    UIAlertAction *huifu = [UIAlertAction actionWithTitle:@"恢复至主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self moveToHomeModel:model];
    
    }];
    [alertCon addAction:huifu];
    
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:cancelAc];
    
    [self presentViewController:alertCon animated:YES completion:nil];
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
