//
//  MoveFolderViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/6.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "MoveFolderViewController.h"
#import "UIViewController+Extension.h"
#import "ResourceFileManager.h"
#import "FolderFileManager.h"
#import "MoveFolderCell.h"
#import "fileModel.h"

@interface MoveFolderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,strong)fileModel *selectedModel;
@end

@implementation MoveFolderViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    _selectedIndex = 0;
    if (self.isSelectedDowload) {
      self.dataArray = [[ResourceFileManager shareInstance] getAllHomePageFolder];
    }else{
        self.dataArray = self.notSelectedFolderArray;
    }
    _selectedModel = self.dataArray.firstObject;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[MoveFolderCell class] forCellReuseIdentifier:@"MoveFolderCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoveFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoveFolderCell" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
    }
    if (self.dataArray.count > 0 && indexPath.row == _selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    [self.tableView reloadData];
    _selectedModel = self.dataArray[indexPath.row];
    if (self.isSelectedDowload) {
        [FolderFileManager shareInstance].downloadFolderPath = _selectedModel.fullPath;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)setUpNav{
    
    if (self.isSelectedDowload) {
        return;
    }
    @weakify(self);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"folder_back"] forState:UIControlStateNormal];
    [btn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        APPdismissViewController(self);
    }];
    [self addLeftItemWithCustomView:btn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [rightBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        NSString *des = self.selectedModel.fullPath;
        for (fileModel *model in self.selectedModelArray) {
            if (self.isCopyFile) {
                [[FolderFileManager shareInstance] copyFileFromPath:model.fullPath toDestionPath:des];
            }else{
             [[FolderFileManager shareInstance] moveFileFromPath:model.fullPath toDestionPath:des];
            }
        }
        POSTNotificationName(FileFinish, nil);
        APPdismissViewController(self);
    }];
    [self addRigthItemWithCustomView:rightBtn];
}

@end
