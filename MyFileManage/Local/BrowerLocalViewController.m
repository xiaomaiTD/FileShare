//
//  browerLocalViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/22.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Photos/Photos.h>
#import "BrowerLocalViewController.h"
#import "localCell.h"
#import "LocalImageModel.h"

@interface BrowerLocalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *localImageArr;

@end

@implementation BrowerLocalViewController

-(NSMutableArray *)localImageArr{
    if (_localImageArr == nil) {
        _localImageArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _localImageArr;
}
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"本地文件";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[localCell class] forCellReuseIdentifier:@"localCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self getAllUserCollection];
}

-(void)getAllUserCollection{
    
    //PHAsset资源 PHCollection 资源的集合
    // PHAssetCollection
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //PHAssetCollection 相册 PHCollectionList文件夹
    PHFetchResult *smartAlbums=  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *asset in smartAlbums) {
        [self.dataSource addObject:asset];
    }
    //PHCollection
    PHFetchResult *userCollection = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:options];
    for (PHCollection *collection in userCollection) {
        [self.dataSource addObject:collection];
    }
    self.localImageArr = [[[self.dataSource firstleap_map:^LocalImageModel *(PHCollection *collection) {
        return [[LocalImageModel alloc] initWithCollection:collection];
    }] firstleap_filter:^BOOL(LocalImageModel *model) {
        return model.count != 0;
    }] copy] ;
    
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    localCell *cell = [tableView dequeueReusableCellWithIdentifier:@"localCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.localImageArr.count > 0) {
        cell.localImage = self.localImageArr[indexPath.row];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.localImageArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
@end
