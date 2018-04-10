//
//  SMBController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/8.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SMBViewController.h"
#import <SMBClient/SMBClient.h>

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
    [self.view addSubview:self.myTable];
    
    [self discoveryDevice];
}

-(void)discoveryDevice{
  
    [[SMBDiscovery sharedInstance] startDiscoveryOfType:SMBDeviceTypeAny added:^(SMBDevice *device) {
        NSLog(@"Device added: %@", device);
        [self.dataSource addObject:device];
        [self.myTable reloadData];
    } removed:^(SMBDevice *device) {
        [self.dataSource removeObject:device];
        [self.myTable reloadData];
        NSLog(@"Device removed: %@", device);
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


@end
