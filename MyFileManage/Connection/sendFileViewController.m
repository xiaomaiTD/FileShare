//
//  sendFileViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/22.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "sendFileViewController.h"
#import "connectionViewController.h"
#import "senderViewController.h"
#import "ResourceFileManager.h"
#import "FolderFileManager.h"
#import "FolderCell.h"
#import "fileModel.h"

@interface sendFileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation sendFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isPushSelf) {
        self.dataSourceArray = [[[FolderFileManager shareInstance] getAllFileModelInDic:self.model.fullPath] mutableCopy];
    }else{
        NSArray *tempArray = [[ResourceFileManager shareInstance] getAllUploadAllFileModels];
        if (tempArray && tempArray.count > 0 ) {
            self.dataSourceArray = tempArray.mutableCopy;
        }
    }
    
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
    [self.collectionView registerClass:[FolderCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
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

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    FolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.dataSourceArray.count >0) {
        cell.model = [self.dataSourceArray objectAtIndex:indexPath.row];
    }
    cell.textView.editable = NO;
    cell.textView.userInteractionEnabled = NO;
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceArray.count > 0) {
        fileModel *model = _dataSourceArray[indexPath.row];
        NSLog(@"model=========%@",model.fullPath);
        //如果是文件夹
        if (model.isFolder) {
            sendFileViewController *vc = [[sendFileViewController alloc] init];
            vc.isPushSelf = YES;
            vc.model = model;
            APPNavPushViewController(vc);
            return;
        }else{
            APPPopViewController([senderViewController class]);
            if ([self.delegate respondsToSelector:@selector(senderFileSelectedModel:)]) {
                [self.delegate senderFileSelectedModel:model];
            }
        }
    }
}

@end
