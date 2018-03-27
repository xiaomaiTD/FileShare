//
//  senderViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "senderViewController.h"
#import "sendFileViewController.h"
#import "openImageViewController.h"
#import "LocalImageAndVideoModel.h"
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

@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property(nonatomic,strong)dispatch_queue_t myQeue;
@property(nonatomic,strong)dispatch_semaphore_t mySem;

@end

@implementation senderViewController

- (void)viewDidDisappear:(BOOL)animated{
    [self.serverManger close];
    self.serverManger = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myQeue = dispatch_queue_create("wangchao.MyFileManage", DISPATCH_QUEUE_SERIAL);
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
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator startAnimating];
    self.indicator.hidesWhenStopped = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
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
    switch (self.type) {
        case sendImageFromAlbum:
            [self sendImageToOther];
            break;
        case sendFileFromLocal:
        {
            sendFileViewController *vc = [[sendFileViewController alloc] init];
            vc.delegate = self;
            APPNavPushViewController(vc);
        }
            break;
        case sendFileFromHome:
            [self sendFileToAnother];
            break;
        default:
            break;
    }
    
}

-(void)sendImageToOther{
    dispatch_async(self.myQeue, ^{
        for (int i = 0; i<self.imageArray.count; i++) {
            LocalImageAndVideoModel *localModel = self.imageArray[i];
            self.mySem = dispatch_semaphore_create(0);
            [GCDQueue executeInMainQueue:^{
               [self sendImage:localModel andIndex:i];
            }];
            dispatch_semaphore_wait(self.mySem, DISPATCH_TIME_FOREVER);
        }
    });
}

-(void)sendImage:(LocalImageAndVideoModel *)model andIndex:(int)index{
    
    AFHTTPSessionManager *mana = [AFHTTPSessionManager manager];
    mana.responseSerializer = [AFHTTPResponseSerializer serializer];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = [NSString stringWithFormat:@"%d",index];
    
    ConnectionItem *item = self.listData[_selectedIndex];
    
    [mana POST:item.GetRemoteAddress parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(model.PHLargeImage);
        [formData appendPartWithFileData:data name:@"uploadnewfile" fileName:model.PHImageName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [GCDQueue executeInMainQueue:^{
            [MBProgressHUD HUDForView:self.view].progress = uploadProgress.fractionCompleted;
            hud.label.text = uploadProgress.localizedDescription;
        }];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(self.mySem);
        [self hidenMessage];
        [self showSuccess];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.mySem);
        [self hidenMessage];
        [self showError];
    }];

    
}

-(void)sendFileToAnother{
    
    dispatch_async(self.myQeue, ^{
        for (int i = 0; i<self.fileModelArray.count; i++) {
            fileModel *localModel = self.fileModelArray[i];
            self.mySem = dispatch_semaphore_create(0);
            [GCDQueue executeInMainQueue:^{
                [self senderFileSelectedModel:localModel andIndex:i];
            }];
            dispatch_semaphore_wait(self.mySem, DISPATCH_TIME_FOREVER);
        }
    });

}

- (void)senderFileSelectedModel:(fileModel *)model andIndex:(NSInteger)index{
    
    ConnectionItem *item = _listData[_selectedIndex];
    AFHTTPSessionManager *mana = [AFHTTPSessionManager manager];
    mana.responseSerializer = [AFHTTPResponseSerializer serializer];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
    NSString *progress;
    if (self.type == sendFileFromHome) {
        NSString *fuHao = @"%0";
        progress = [NSString stringWithFormat:@"%ld(%@...)",index,fuHao];
    }else{
        progress = @"%0...";
    }
    
    hud.label.text = progress;
    
    [mana POST:item.GetRemoteAddress parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfFile:model.fullPath];
        [formData appendPartWithFileData:data name:@"uploadnewfile" fileName:model.name mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        [GCDQueue executeInMainQueue:^{
            [MBProgressHUD HUDForView:self.view].progress = uploadProgress.fractionCompleted;
            NSString *progress;
            if (self.type == sendFileFromHome) {
                progress = [NSString stringWithFormat:@"%ld(%@...)",index,uploadProgress.localizedDescription];
            }else{
                progress = uploadProgress.localizedDescription;
            }
            hud.label.text = progress;
        }];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hidenMessage];
        [self showSuccess];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hidenMessage];
        [self showError];
    }];

    
}

#pragma mark ------sendFileViewControllerDelegate

/**
 发送文件

 @param model 文件model
 */
-(void)senderFileSelectedModel:(fileModel *)model{
    [self senderFileSelectedModel:model andIndex:0];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.listData.count > 0) {
        ConnectionItem *model = self.listData[indexPath.row];
        cell.textLabel.text = model.name;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listData.count > 0) {
        _selectedIndex = indexPath.row;
        [self buttonFinishedClick];
    }
}

@end
