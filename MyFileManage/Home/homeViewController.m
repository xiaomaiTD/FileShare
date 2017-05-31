//
//  homeViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "homeViewController.h"
#import "ConnectWifiWebViewController.h"
#import "openImageViewController.h"
#import "playVideoViewController.h"



#import "fileModel.h"



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
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
    NSArray *tempArray = [self getAllUploadAllFileNames];
    
     if (tempArray && tempArray.count > 0 ) {
        
        [self.dataSourceArray addObjectsFromArray:tempArray];
 
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [self configueNavItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileFinishAndReloadTable) name:FileFinish object:nil];

    
    
}

-(void)configueNavItem{

    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftItem addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftItem setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
    
    
    leftItem.frame = CGRectMake(0, 0, 25, 25);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    
    UIButton *addfile = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    [addfile setTintColor:[UIColor orangeColor]];
    
    addfile.frame = CGRectMake(0, 0, 25, 25);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addfile];
    
}


-(void)leftItemClick:(UIButton *)sender{


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
        
        
        fileModel *model = _dataSourceArray[indexPath.row];
        
        cell.textLabel.text = model.fileName;
    }
    
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_dataSourceArray.count > 0) {
        
        fileModel *model = _dataSourceArray[indexPath.row];
        
        if ([SupportPictureArray containsObject:[model.fileType uppercaseString]]) {
            
            openImageViewController *vc = [[openImageViewController alloc] init];
            
            vc.model = model;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([SupportVideoArray containsObject:[model.fileType uppercaseString]]) {
            
            playVideoViewController *vc = [[playVideoViewController alloc] init];
            
            vc.model = model;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        
    }




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
    
   __block NSMutableArray *fileModelArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        NSString *fileString = [NSString stringWithFormat:@"%@",obj];
        //.DS_Store
        if (![fileString isEqualToString:@".DS_Store"]) {
            
            fileModel *model = [[fileModel alloc] initWithFileString:[NSString stringWithFormat:@"%@",obj]];
            
            [fileModelArray addObject:model];
            

            
        }
        
    }];
    
    
    return fileModelArray;
    
}



@end
