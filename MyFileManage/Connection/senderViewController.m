//
//  senderViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "senderViewController.h"
#import "sendFileViewController.h"
#import "UdpServerManager.h"
#import "ConnectionItem.h"
#import "fileModel.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface senderViewController ()
<UITableViewDelegate,UITableViewDataSource,senderFileViewControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *listData;
@property(nonatomic,strong)UdpServerManager *serverManger;
@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,strong)NSURLSessionUploadTask *task;

@end

@implementation senderViewController

- (void)viewDidDisappear:(BOOL)animated{
    [self.serverManger close];
    self.serverManger = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedIndex = 0;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonFinishedClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    self.listData = [[NSMutableArray alloc] init];
    self.serverManger = [[UdpServerManager alloc] init];
    [self.serverManger start];
    //接收到用户通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveIpFinished:) name:kNotificationIPReceivedFinishd object:nil];

}
//接收到ip地址
- (void)receiveIpFinished:(NSNotification*)notifice{
    ConnectionItem *mod=(ConnectionItem*)[notifice object];
    if (![self isExistsConnection:mod]) {
        [self.listData addObject:mod];
        [self.tableView reloadData];
    }
}
- (BOOL)isExistsConnection:(ConnectionItem*)mod{
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"self.host =%@",mod.host];
    NSArray *arr=[self.listData filteredArrayUsingPredicate:pred];
    return arr&&[arr count]>0;
}
-(void)buttonFinishedClick{
    if (self.listData.count == 0) {
        [self showError];
        return;
    }
    sendFileViewController *vc = [[sendFileViewController alloc] init];
    vc.delegate = self;
    APPNavPushViewController(vc);
}
#pragma mark ------sendFileViewControllerDelegate

/**
 发送文件

 @param model 文件model
 */
-(void)senderFileSelectedModel:(fileModel *)model{
    
    ConnectionItem *item = _listData[_selectedIndex];
    NSLog(@"port=====%hu",item.port);
    
    AFHTTPSessionManager *mana = [AFHTTPSessionManager manager];
    mana.responseSerializer = [AFHTTPResponseSerializer serializer];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = @"%0...";

    [mana POST:item.GetRemoteAddress parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfFile:model.fullPath];
        [formData appendPartWithFileData:data name:@"uploadnewfile" fileName:model.name mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [GCDQueue executeInMainQueue:^{
            [MBProgressHUD HUDForView:self.view].progress = uploadProgress.fractionCompleted;
            hud.label.text = uploadProgress.localizedDescription;
        }];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hidenMessage];
        [self showSuccess];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hidenMessage];
        [self showError];
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.listData.count > 0) {
        ConnectionItem *model = self.listData[indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

@end
