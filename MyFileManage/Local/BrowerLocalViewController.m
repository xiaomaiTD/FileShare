//
//  browerLocalViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/22.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Photos/Photos.h>
#import "BrowerLocalListViewController.h"
#import "UIViewController+Extension.h"
#import "BrowerLocalViewController.h"
#import "LocalImageModel.h"
#import "localCell.h"


@interface BrowerLocalViewController ()<UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,copy)NSArray *localImageArr;

@end

@implementation BrowerLocalViewController

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[localCell class] forCellReuseIdentifier:@"localCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self getAllUserCollection];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self configueNavItem];
}

-(void)configueNavItem{
    UIButton *addfile = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addfile setTintColor:[UIColor orangeColor]];
    addfile.frame = CGRectMake(0, 0, 25, 25);
    @weakify(self);
    [addfile addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self addAlbum];
    }];
    [self addRigthItemWithCustomView:addfile];
}

/**
 添加相册
 */
-(void)addAlbum{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"创建相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入相册名字";
    }];
    UIAlertAction *textAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alertCon.textFields.firstObject;
        if (field.text.length == 0) {
            return ;
        }
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
               [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:field.text];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                [self showErrorWithTitle:@"相册创建失败"];
            }
        }];
        
    }];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCon addAction:textAc];
    [alertCon addAction:cancelAc];
    [self presentViewController:alertCon animated:YES completion:nil];
}

-(void)getAllUserCollection{
    
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
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
    self.localImageArr = [[[self.dataSource firstleap_map:^LocalImageModel *(PHAssetCollection *collection) {
        return [[LocalImageModel alloc] initWithCollection:collection];
    }] firstleap_filter:^BOOL(LocalImageModel *model) {
        //type == 1
        return model.collection.assetCollectionType == 1 || model.count != 0;
    }] copy] ;
    
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    localCell *cell = [tableView dequeueReusableCellWithIdentifier:@"localCell" forIndexPath:indexPath];
    if (self.localImageArr.count > 0) {
        cell.localImage = self.localImageArr[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BrowerLocalListViewController *list = [[BrowerLocalListViewController alloc] init];
    LocalImageModel *model = _localImageArr[indexPath.row];
    list.fetResult = model.result;
    list.assetCollection = model.collection;
    APPNavPushViewController(list);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.localImageArr.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.localImageArr.count > 0) {
        LocalImageModel *model = _localImageArr[indexPath.row];
        if (model.collection.assetCollectionType == 2) {
            return NO;
        }
    }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteAlbumWithIndexPath:indexPath];
    }];
    
    //添加一个编辑按钮
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self editAlbumWithIndexPath:indexPath];
    }];
    editAction.backgroundColor = [UIColor greenColor];
    
    return @[deleteAction, editAction];
    
}
/**
 删除相册
 */

-(void)deleteAlbumWithIndexPath:(NSIndexPath *)indexPath{
    
    LocalImageModel *collection = self.localImageArr[indexPath.row];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest deleteAssetCollections:@[collection.collection]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            [GCDQueue executeInMainQueue:^{
                [self showErrorWithTitle:@"相册删除失败"];
            }];
        }
    }];
}

/**
 编辑相册
 */

-(void)editAlbumWithIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"重新命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入相册名字";
    }];
    UIAlertAction *textAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alertCon.textFields.firstObject;
        if (field.text.length == 0) {
            return ;
        }
        LocalImageModel *collection = self.localImageArr[indexPath.row];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *request =  [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection.collection];
            request.title = field.text;
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (!success) {
                [GCDQueue executeInMainQueue:^{
                    [self showErrorWithTitle:@"命名成功"];
                }];
            }
        }];
    }];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertCon addAction:textAc];
    [alertCon addAction:cancelAc];
    [self presentViewController:alertCon animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)photoLibraryDidChange:(PHChange *)changeInstance{
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [GCDQueue executeInMainQueue:^{
           [self getAllUserCollection];
        }];
    }
}
@end
