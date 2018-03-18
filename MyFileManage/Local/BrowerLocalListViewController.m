//
//  BrowerLocalListViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BrowerLocalListViewController.h"
#import "PlayLocalVideoViewController.h"
#import "senderViewController.h"
#import "openImageViewController.h"
#import "localImageAndVideoCell.h"
#import "LocalImageAndVideoModel.h"
#import "UIViewController+Extension.h"
#import "LocalBottomView.h"


@interface BrowerLocalListViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)UIButton *selectedBtn;
@property(nonatomic,strong)LocalBottomView *bottomView;
@property(nonatomic,assign)BOOL selected;

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
    self.selected = NO;
    [self setUI];
    [self requestAllSource];
    
    _bottomView = [[LocalBottomView alloc] initWithFrame:CGRectZero];
    _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    @weakify(self);
    [_bottomView.deleteBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self deleteSelectedAssert];
    }];
    [_bottomView.sendBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self sendPhotoToOther];
    }];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.view).offset(60);
    }];
}

-(void)judgeSelectAssertsCanDelete{
    
    NSArray *selectedArray = [[self.dataSourceArray firstleap_filter:^BOOL(LocalImageAndVideoModel *model) {
        return model.selected;
    }] firstleap_map:^PHAsset *(LocalImageAndVideoModel *model) {
        return model.phasset;
    }];
    BOOL canDelete = false;
    for (PHAsset *asset in selectedArray) {
        canDelete = [asset canPerformEditOperation:PHAssetEditOperationDelete];
        _bottomView.deleteBtn.enabled = canDelete;
        if (!canDelete) {
            break;
        }
    }
}

-(void)deleteSelectedAssert{
    
    NSArray *selectedArray = [self.dataSourceArray firstleap_filter:^BOOL(LocalImageAndVideoModel *model) {
        return model.selected;
    }];
    void(^completion)(BOOL,NSError *) = ^(BOOL success,NSError *eror){
        [GCDQueue executeInMainQueue:^{
            if (success) {
                [self showSuccess];
                [self.dataSourceArray removeObjectsInArray:selectedArray];
                [self.collectionView reloadData];
            }else{
                [self showErrorWithTitle:eror.localizedDescription];
            }
        }];
    };
    [PHPhotoLibrary.sharedPhotoLibrary performChanges:^{
        NSArray *selectedAssetArray = [selectedArray firstleap_map:^PHAsset *(LocalImageAndVideoModel *model) {
            return model.phasset;
        }];
        [PHAssetChangeRequest deleteAssets:selectedAssetArray];
    } completionHandler:completion];
}

-(void)sendPhotoToOther{
    [self showMessageWithTitle:@"请稍后.."];
    [GCDQueue executeInGlobalQueue:^{
        NSArray *imageArray = [[self.dataSourceArray firstleap_filter:^BOOL(LocalImageAndVideoModel *model) {
            return model.selected;
        }] firstleap_map:^LocalImageAndVideoModel *(LocalImageAndVideoModel *model) {
            return [model requestLargeImage];
        }];
        [GCDQueue executeInMainQueue:^{
            [self hidenMessage];
            senderViewController *vc = [[senderViewController alloc] init];
            vc.type = sendImageFromAlbum;
            vc.imageArray = imageArray;
            APPNavPushViewController(vc);
        }];
    }];
    
}

-(void)setUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(floor((kScreenWidth - 40)/3.0), floor((kScreenWidth - 40)/3.0));
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

    UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [edit setTitle:@"选择" forState:UIControlStateNormal];
    [edit setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [edit setTitle:@"取消" forState:UIControlStateSelected];
    [edit setTitleColor:MAINCOLOR forState:UIControlStateSelected];
    [self addRigthItemWithCustomView:edit];
    @weakify(self);
    [edit addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        sender.selected = !sender.isSelected;
        if (sender.isSelected == YES) {
            self.selected = YES;
            [self popBottomView];
            [self.selectedBtn setImage:[UIImage new] forState:UIControlStateNormal];
            [self.selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
            [self.selectedBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        }else{
            self.selected = NO;
            [self hiddenBottomView];
            [self cancleAllModel];
            [self.selectedBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [self.selectedBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }];

    UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.selectedBtn = selectedBtn;
    selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectedBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [selectedBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        if ([sender.currentTitle isEqualToString:@"全选"]) {
            [self selectedAllModel];
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    CGFloat kScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnW = kScreenW > 375.0 ? 50:40;
    selectedBtn.frame = CGRectMake(0, 0, btnW, 40);
    [self addLeftItemWithCustomView:selectedBtn];
    
}

-(void)selectedAllModel{
    
    self.dataSourceArray = [self.dataSourceArray firstleap_map:^LocalImageAndVideoModel *(LocalImageAndVideoModel *model) {
        model.selected = YES;
        return model;
    }].mutableCopy;
    [self.collectionView reloadData];
}
-(void)cancleAllModel{
    self.dataSourceArray = [self.dataSourceArray firstleap_map:^LocalImageAndVideoModel *(LocalImageAndVideoModel *model) {
        model.selected = NO;
        return model;
    }].mutableCopy;
    [self.collectionView reloadData];
}

-(void)popBottomView{
    [UIView animateWithDuration:0.25 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(0);
            make.height.mas_equalTo(60);
            make.bottom.equalTo(self.view).offset(0);
        }];
        [self.bottomView.superview layoutIfNeeded];
    }];
}

-(void)hiddenBottomView{
    [UIView animateWithDuration:0.25 animations:^{
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(0);
            make.height.mas_equalTo(60);
            make.bottom.equalTo(self.view).offset(60);
        }];
        [self.bottomView.superview layoutIfNeeded];
    }];
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
        if (self.selected) {
            model.selected = !model.selected;
            [collectionView reloadData];
            [self judgeSelectAssertsCanDelete];
            return;
        }
        if (model.type == PHASSETTYPE_LivePhoto || model.type == PHASSETTYPE_Image) {
            openImageViewController *vc = [[openImageViewController alloc] init];
            vc.localModel = model;
            APPNavPushViewController(vc);
        }
        if (model.type == PHASSETTYPE_Video) {
            PlayLocalVideoViewController *vc = [[PlayLocalVideoViewController alloc] init];
            vc.localModel = model;
            APPNavPushViewController(vc);
        }
        
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
