//
//  SMBController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/8.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import "UIViewController+Extension.h"
#import "SMBBrowListViewController.h"
#import <SMBClient/SMBClient.h>
#import "MBProgressHUD+Vi.h"
#import "SMBViewController.h"
#import "EasyAlertView.h"

@interface SMBViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *myTable;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation SMBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTable.tableFooterView = [[UIView alloc] init];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.myTable];
    
    [self discoveryDevice];
    [self configueLeftNavItem];
}

-(void)configueLeftNavItem{
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh"]];
    refreshBtn.bounds = imgV.bounds;
    [refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    
    @weakify(self);
    [refreshBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self discoveryDevice];
    }];
    [self addLeftItemWithCustomView:refreshBtn];
    
}

- (void)viewDidDisappear:(BOOL)animated{

    [[SMBDiscovery sharedInstance] stopDiscovery];
}

-(void)discoveryDevice{
    self.dataSource = @[].mutableCopy;
    [[SMBDiscovery sharedInstance] startDiscoveryOfType:SMBDeviceTypeAny added:^(SMBDevice *device) {
        [self.dataSource addObject:device];
        [self.myTable reloadData];
    } removed:^(SMBDevice *device) {
        [self.dataSource removeObject:device];
        [self.myTable reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataSource.count > 0) {
        SMBDevice *device = self.dataSource[indexPath.row];
        cell.textLabel.text = device.host;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *actionArray = @[@{@"确定":@(0)},@{@"取消":@(0)}];
    EasyAlertView *alert = [[EasyAlertView alloc] initWithType:AlertViewAlert andTitle:@"请输入账号密码" andActionArray:actionArray andActionBlock:^(NSString *title, NSInteger index,NSArray *textFieldArray) {
        if (index == 0) {
            UITextField *userName = textFieldArray.firstObject;
            UITextField *passWord = textFieldArray[1];
            if (userName.text.length == 0 ||passWord.text.length == 0) {
                [MBProgressHUD showTopError:@"账号名或者密码为空"];
                return;
            }
            [self connectInternetWithUser:userName.text andPassword:passWord.text andIndexPath:indexPath];
        }
    }];
    
    [alert addTextFieldWithBlock:^(UITextField *textField) {
        textField.placeholder = @"账号";
        textField.text = @"Viterbi";
    }];
    [alert addTextFieldWithBlock:^(UITextField *textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"密码";
        textField.text = @"123456";
    }];
    
    [alert showInViewController:self];
}

-(void)connectInternetWithUser:(NSString *)username andPassword:(NSString *)password andIndexPath:(NSIndexPath *)indexpath{
    SMBDevice *device = self.dataSource[indexpath.row];
    NSString *host = device.host;
    
    SMBFileServer *fileServer = [[SMBFileServer alloc] initWithHost:host netbiosName:host group:nil];
    [self showMessageWithTitle:@"正在登录..."];
        
    [fileServer connectAsUser:username password:password completion:^(BOOL guest, NSError *error) {
        [self hidenMessage];
        if (error) {
            NSLog(@"Unable to connect: %@", error);
            [self showErrorWithTitle:@"登录失败"];
        } else {
            SMBBrowListViewController *vc = [[SMBBrowListViewController alloc] init];
            vc.fileServer = fileServer;
            APPNavPushViewController(vc);
        }
    }];
}

-(void)dealloc{
    NSLog(@"dealloc");
}


@end
