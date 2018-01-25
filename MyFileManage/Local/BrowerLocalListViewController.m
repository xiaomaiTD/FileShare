//
//  BrowerLocalListViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BrowerLocalListViewController.h"
#import "openImageViewController.h"
#import "localImageAndVideoCell.h"
#import "LocalImageAndVideoModel.h"


@interface BrowerLocalListViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation BrowerLocalListViewController

-(NSMutableArray *)dataSourceArray{
    if (_dataSourceArray == nil) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 40)/3.0, (kScreenWidth - 40)/3.0);
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[localImageAndVideoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self requestAllSource];
}

/**
 获取所有资源
 */
-(void)requestAllSource{
    [GCDQueue executeInGlobalQueue:^{
        for (PHAsset *asset in _fetResult) {
            LocalImageAndVideoModel *model =[[LocalImageAndVideoModel alloc] initWithAsset:asset];
            [self.dataSourceArray addObject:model];
        }
        [GCDQueue executeInMainQueue:^{
           [self.collectionView reloadData];
        }];
    }];
}
#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//（上、左、下、右）
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSourceArray.count > 0) {
        LocalImageAndVideoModel *model = self.dataSourceArray[indexPath.row];
        openImageViewController *vc = [[openImageViewController alloc] init];
        vc.localModel = model;
        APPNavPushViewController(vc);
    }
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    localImageAndVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (_dataSourceArray.count > 0) {
        cell.model = _dataSourceArray[indexPath.row];
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
