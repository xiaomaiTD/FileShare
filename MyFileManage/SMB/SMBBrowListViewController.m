//
//  SMBBrowListViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/12.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SMBBrowListViewController.h"
#import "NSString+CHChinese.h"
#import "PlayVideoViewController.h"
#import "FileDownloadManager.h"
#import "FileDownloaderOperation.h"
#import <MJRefresh/MJRefresh.h>
#import "MBProgressHUD+Vi.h"
#import "GloablVarManager.h"
#import "SMBFolderCell.h"

@interface SMBBrowListViewController ()
<UITableViewDelegate,UITableViewDataSource,SMBFolderCellDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation SMBBrowListViewController

-(NSMutableArray *)dataSourceArray{
    if (_dataSourceArray == nil) {
        _dataSourceArray = @[].mutableCopy;
    }
    return _dataSourceArray;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[SMBFolderCell class] forCellReuseIdentifier:@"SMBFolderCell"];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestDataSource];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
-(void)requestDataSource{
    
    [self showMessage];
    if (self.fileServer) {
        @weakify(self);
        [self.fileServer listShares:^(NSArray<SMBShare *> * _Nullable shares, NSError * _Nullable error) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self hidenMessage];
            self.dataSourceArray = shares.mutableCopy;
            [self.tableView reloadData];
        }];
    }
    if (self.share) {
        @weakify(self);
        [self.share open:^(NSError * _Nullable error) {
            [self hidenMessage];
            @strongify(self);
            if (error != nil) {
                [MBProgressHUD showTopError:@"文件未能打开，请返回上一界面"];
                return;
            }
            [self.share listFiles:^(NSArray<SMBFile *> * _Nullable files, NSError * _Nullable error) {
                [self.tableView.mj_header endRefreshing];
                self.dataSourceArray = files.mutableCopy;
                [self.tableView reloadData];
            }];
        }];
    }
    if (self.file) {
        @weakify(self);
        [self.file listFiles:^(NSArray<SMBFile *> * _Nullable files, NSError * _Nullable error) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self hidenMessage];
            self.dataSourceArray = files.mutableCopy;
            [self.tableView reloadData];
        }];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMBFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMBFolderCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (self.dataSourceArray.count > 0) {
        if (self.fileServer) {
            SMBShare *share = self.dataSourceArray[indexPath.row];
            cell.share = share;
        }else{
            SMBFile *file = self.dataSourceArray[indexPath.row];
            cell.file = file;
        }
    }
    return cell;
}
#pragma mark -----SMBFolderCellDelegate

-(void)downloadFileCallback:(SMBFile *)smfile{


    NSUInteger bufferSize = 12000;
    NSMutableData *result = [NSMutableData new];
    
    [smfile read:bufferSize
      progress:^BOOL(unsigned long long bytesReadTotal, NSData *data, BOOL complete, NSError *error) {
          
          if (error) {
              NSLog(@"Unable to read from the file: %@", error);
          } else {
              NSLog(@"Read %ld bytes, in total %llu bytes (%0.2f %%)",
                    data.length, bytesReadTotal, (double)bytesReadTotal / smfile.size * 100);
              
              if (data) {
                  [result appendData:data];
              }
          }
          
          if (complete) {
              [smfile close:^(NSError *error) {
                  NSLog(@"Finished reading file");
              }];
          }
          
          return YES;
      }];
}

-(void)watchVideoCallback:(SMBFile *)smfile{
    [self watchVideoWithFile:smfile];
}

-(void)watchVideoWithFile:(SMBFile *)file{
    
    [GloablVarManager shareManager].SMBFilePath = file.path;
    NSString *path = [GloablVarManager shareManager].SMBFullPath;
    if ([path ch_containsChinese:CHNSStringChineseTypeAll]) {
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    path = [NSString stringWithFormat:@"smb://%@",path];
    PlayVideoViewController *vc = [[PlayVideoViewController alloc] init];
    vc.path = path;
    APPPresentViewController(vc);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.fileServer) {
        SMBBrowListViewController *list = [[SMBBrowListViewController alloc] init];
        SMBShare *share = self.dataSourceArray[indexPath.row];
        [GloablVarManager shareManager].SMBFirstShareName = share.name;
        list.share = share;
        APPNavPushViewController(list);
    }else{
        SMBFile *file = self.dataSourceArray[indexPath.row];
        if (!file.isDirectory && [SupportVideoArray containsObject:[file.path.pathExtension uppercaseString]]) {
            [self watchVideoWithFile:file];
            return;
        }
        if (file.isDirectory) {
            SMBBrowListViewController *list = [[SMBBrowListViewController alloc] init];
            list.file = file;
            APPNavPushViewController(list);
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
@end
