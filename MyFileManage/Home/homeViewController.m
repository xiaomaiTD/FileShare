//
//  homeViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "homeViewController.h"
#import "ConnectWifiWebViewController.h"


@interface homeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation homeViewController

-(NSMutableArray *)dataSourceArray{

    if (!_dataSourceArray) {
        
       _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
       
    }
    return _dataSourceArray;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
    NSArray *tempArray = [self getAllUploadAllFileNames];
    
     if (tempArray && tempArray.count > 0 ) {
        
        [self.dataSourceArray addObjectsFromArray:tempArray];
 
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileFinishAndReloadTable) name:FileFinish object:nil];
    
    
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightItem addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightItem setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
    
    
    rightItem.frame = CGRectMake(0, 0, 25, 25);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    
    
}


-(void)rightItemClick:(UIButton *)sender{


    ConnectWifiWebViewController *vc = [[ConnectWifiWebViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.textLabel.text=@"这是测试数据";
    }
    
    if (_dataSourceArray.count > 0) {
        
        cell.textLabel.text = _dataSourceArray[indexPath.row];
    }
    
    
    return cell;
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSourceArray.count;
    
}


-(void)fileFinishAndReloadTable{
    
    [self.dataSourceArray removeAllObjects];
    
    NSArray *allFiles = [self getAllUploadAllFileNames];
    
    [self.dataSourceArray addObjectsFromArray:allFiles];
    
    [self.tableView reloadData];
    
  //  NSLog(@"allFiles-----%@",allFiles);
    
}

- (NSArray *) getAllUploadAllFileNames
{
   
 
   NSString *uploadDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
 
    uploadDirPath = [NSString stringWithFormat:@"%@/MyFileManageUpload",uploadDirPath];
 
 
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:uploadDirPath error:nil];
    
    return files;
    
}



@end
