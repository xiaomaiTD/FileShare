//
//  SMBController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/8.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import "UIViewController+Extension.h"
#import <SMBClient/SMBClient.h>
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
    
//    NSString *host = @"192.168.1.107";
//
//    SMBFileServer *fileServer = [[SMBFileServer alloc] initWithHost:host netbiosName:host group:nil];
//
//    [fileServer connectAsUser:@"Viterbi" password:@"123456" completion:^(BOOL guest, NSError *error) {
//        if (error) {
//            NSLog(@"Unable to connect: %@", error);
//        } else if (guest) {
//            NSLog(@"Logged in as guest");
//        } else {
//            NSLog(@"Logged in");
//        }
//
//        [fileServer listShares:^(NSArray<SMBShare *> * _Nullable shares, NSError * _Nullable error) {
//
//        }];
//    }];
    NSArray *actionArray = @[@{@"确定":@(0)},@{@"取消":@(0)}];
    EasyAlertView *alert = [[EasyAlertView alloc] initWithType:AlertViewAlert andTitle:@"请输入账号密码" andActionArray:actionArray andActionBlock:^(NSString *title, NSInteger index,NSArray *textFieldArray) {
        UITextField *filed = textFieldArray.firstObject;
        NSLog(@"filed------%@",filed.text);
    }];
    
    [alert addTextFieldWithBlock:^(UITextField *textField) {
        textField.placeholder = @"账号";
    }];
    [alert addTextFieldWithBlock:^(UITextField *textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"密码";
    }];
    
    [alert showInViewController:self];
    
    
}


@end
