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

@interface senderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *listData;
@property (nonatomic,strong) UdpServerManager *serverManger;

@end

@implementation senderViewController

- (void)viewDidDisappear:(BOOL)animated{
    [self.serverManger close];
    self.serverManger = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    sendFileViewController *vc = [[sendFileViewController alloc] init];
    APPNavPushViewController(vc);
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
