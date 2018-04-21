//
//  homeViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <SSZipArchive/SSZipArchive.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <KVOController/KVOController.h>
#import "NSFileManager+GreatReaderAdditions.h"
#import "UIViewController+Extension.h"
#import "HomeFolderViewController.h"
#import "SPWaterFlowLayout.h"

#import "MoveFolderViewController.h"
#import "senderViewController.h"

#import "ResourceFileManager.h"
#import "FolderFileManager.h"
#import "GloablVarManager.h"
#import "DataBaseTool.h"
#import "FMDBTool.h"

#import "SelectedFolderCell.h"
#import "HomeToolBarView.h"
#import "EasyAlertView.h"
#import "FolderCell.h"
#import "GCD.h"

@interface HomeFolderViewController ()
<
UICollectionViewDelegate,UICollectionViewDataSource,SSZipArchiveDelegate,FolderCellDelegate
>

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)FBKVOController *KVOController;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,strong)UIButton *leftItem;
@property(nonatomic,strong)UIButton *editItem;
@property(nonatomic,strong)HomeToolBarView *editTarView;

@end

@implementation HomeFolderViewController

-(HomeToolBarView *)editTarView{
    if (_editTarView) {
        return _editTarView;
    }
    _editTarView = [[HomeToolBarView alloc] init];
    return _editTarView;
}

-(NSMutableArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isPushSelf) {
        self.dataSourceArray = [[[FolderFileManager shareInstance] getAllFileModelInDic:self.model.fullPath] mutableCopy];
    }else{
        NSArray *tempArray = [[ResourceFileManager shareInstance] getAllUploadAllFileModels];
        self.dataSourceArray = [tempArray mutableCopy];
    }
    SPWaterFlowLayout *flowlayout = [[SPWaterFlowLayout alloc] init];
    flowlayout.columnNumber = 3;
    flowlayout.interitemSpacing = 10;
    flowlayout.lineSpacing = 10;
    flowlayout.pageSize = self.dataSourceArray.count;
    flowlayout.datas = self.dataSourceArray.copy;
    flowlayout.reuseIdentifier = @"FolderCell";
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    flowLayout.minimumLineSpacing = 10;
//    flowLayout.minimumInteritemSpacing = 10;
//    flowLayout.itemSize = CGSizeMake(floor((kScreenWidth - 40)/3.0), floor((kScreenWidth - 40)/3.0));
    //设置CollectionView的属性
//    flowLayout.estimatedItemSize = CGSizeMake(floor((kScreenWidth - 40)/3.0), self.view.height - 20);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[FolderCell class] forCellWithReuseIdentifier:@"FolderCell"];
    [self.collectionView registerClass:[SelectedFolderCell class] forCellWithReuseIdentifier:@"SelectedFolderCell"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileFinishAndReloadTable) name:FileFinish object:nil];
    // 监听 
    [self addKVO];
    [self configueNavItem];
    [self setBasicUI];
}

-(void)addKVO{
    
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    // 显示文件后缀
    @weakify(self);
    [self.KVOController observe:[GloablVarManager shareManager] keyPath:@"showFolderType" options: NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        BOOL show = [change[@"new"] intValue];
        [[DataBaseTool shareInstance] setShowFileTypeHidden:show];
        [self fileFinishAndReloadTable];
    }];
    // 是否显示隐藏文件夹
    [self.KVOController observe:[GloablVarManager shareManager] keyPath:@"showHiddenFolder" options: NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        BOOL show = [change[@"new"] intValue];
        @strongify(self);
        [[DataBaseTool shareInstance] setShowHiddenFolderHidden:show];
        [self fileFinishAndReloadTable];
    }];
}

-(void)setBasicUI{
    [self.view addSubview:self.editTarView];
    [self.editTarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_offset(0);
        make.top.mas_equalTo(kScreenHeight);
        make.size.with.mas_equalTo(49);
    }];
    
    @weakify(self);
    [self.editTarView.moveBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        
        MoveFolderViewController *moveF = [self getFolderMoveWithCopy:NO];;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:moveF];
        APPPresentViewController(nav);
    }];
    
    [self.editTarView.fuZhiBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        MoveFolderViewController *moveF = [self getFolderMoveWithCopy:YES];;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:moveF];
        APPPresentViewController(nav);
    }];

    [self.editTarView.shareBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        if ([self judgeHaveAllPhoto]) {
//            [self shareClick];
        }
    }];

    [self.editTarView.sender addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        senderViewController *svc = [[senderViewController alloc] init];
        svc.type = sendFileFromHome;
        svc.fileModelArray = [self selectedModelsArrayWithFolder];
        APPNavPushViewController(svc);
    }];

    [self.editTarView.deleteBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self deleteSelectedModelArray];
    }];

}

//判断是不是选中一个，并且是图片类型
-(BOOL)judgeHaveAllPhoto{
    
    NSArray *selected = [self selectedModelsArray];
    if (selected.count > 1) {
        [self showErrorWithTitle:@"不可分享多个对象"];
        return NO;
    }
    fileModel *model = selected.firstObject;
    if ([SupportPictureArray containsObject:[model.fileType uppercaseString]]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)shareClick{
    
    fileModel *model = [self selectedModelsArray].firstObject;
    
    NSString *textToShare = model.fileName;
    UIImage *imageToShare = [[UIImage alloc] initWithContentsOfFile:model.fullPath];
//    NSURL *urlToShare = [NSURL URLWithString:@"https://github.com/ViterbiDevelopment"];
    NSArray *activityItems = @[textToShare,imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化回调方法
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError){
            if (completed){
                [self showSuccessWithTitle:@"complete"];
            }
            else{
                 [self showErrorWithTitle:@"cancle"];
            }
        };
        activityVC.completionWithItemsHandler = myBlock;
    }else{
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            if (completed){
                [self showSuccessWithTitle:@"complete"];
            }else{
                [self showErrorWithTitle:@"cancle"];
            }
        };
        activityVC.completionHandler = myBlock;
    }
    [self presentViewController:activityVC animated:YES completion:nil];

}

-(void)deleteSelectedModelArray{
    
    NSArray *actionArray = @[@{@"删除":@(2)},@{@"取消":@(1)}];
    
    EasyAlertView *alert = [[EasyAlertView alloc] initWithType:1 andTitle:@"是否删除该文件" andActionArray:actionArray andActionBlock:^(NSString *title, NSInteger index,NSArray *textFieldArray) {
        
        if (index == 0) {
            NSArray *selectedArray = [self selectedModelsArray];
            for (fileModel *model in selectedArray) {
                [[FolderFileManager shareInstance] moveToRecyleFolderFromPath:model.fullPath];
            }
            [self fileFinishAndReloadTable];
        }
    }];
    
    [alert showInViewController:self];
}

-(MoveFolderViewController *)getFolderMoveWithCopy:(BOOL)isCopy{
    
    NSMutableArray *selectedArray = [self selectedModelsArray];
    MoveFolderViewController *moveF = [[MoveFolderViewController alloc] init];
    moveF.isCopyFile = isCopy;
    moveF.notSelectedFolderArray = [self theFolderNoSelected];
    moveF.selectedModelArray = selectedArray;
    return moveF;
}

-(void)configueNavItem{
    
    UIButton *addfile = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addfile setTintColor:[UIColor orangeColor]];
    addfile.frame = CGRectMake(0, 0, 25, 25);
    @weakify(self);
    [addfile addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self addFolderText:sender];
    }];
    UIBarButtonItem *itemOne = [[UIBarButtonItem alloc] initWithCustomView:addfile];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editItem = editBtn;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(0, 0, 40, 40);
    
    [editBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self editClick:sender];
    }];
    UIBarButtonItem *itemTwo = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItems = @[itemOne,itemTwo];
    
    
    self.leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftItem.bounds = CGRectMake(0, 0, 40, 40);
    if (self.isPushSelf) {
        [self.leftItem setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        self.leftItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }else{
        self.leftItem.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.leftItem setTitle:@"全选" forState:UIControlStateNormal];
        [self.leftItem setTitle:@"反选" forState:UIControlStateSelected];
    }
    [self.leftItem addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        if (self.isPushSelf) {
            if ([sender.currentTitle isEqualToString:@"全选"]) {
                [self selectedAllModel];
                [self.editTarView setHomeBarIsHidden:YES];
            }else{
             [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            sender.selected = !sender.isSelected;
            if (sender.isSelected) {
                [self selectedAllModel];
                [self.editTarView setHomeBarIsHidden:YES];
            }else{
                [self resertAllModel];
                [self.editTarView setHomeBarIsHidden:NO];
            }
        }
    }];
    [self.leftItem setTitleColor:[UIColor blackColor]];
    self.leftItem.hidden = self.isPushSelf ? NO:YES;
    [self addLeftItemWithCustomView:self.leftItem];
    
}

-(void)editClick:(UIButton *)sender{
    self.selected = !self.selected;
    sender.selected = !sender.isSelected;
    [self goDownUpTabbar];
    [self goUpEditHomeBarView];
    [self resertAllModel];
    [self.collectionView reloadData];
    if (self.isPushSelf) {
        if (sender.isSelected) {
            [self.leftItem setTitle:@"全选" forState:UIControlStateNormal];
            [self.leftItem setDefont:15];
            [self.leftItem setImage:[UIImage new] forState:UIControlStateNormal];
        }else{
            [self.leftItem setTitle:@"" forState:UIControlStateNormal];
            [self.leftItem setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            self.leftItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
    }else{
        self.leftItem.hidden = !self.selected;
    }

}

-(NSArray*)theFolderNoSelected{
    
    NSArray *NotBeSelectedFolderArray = [self.dataSourceArray firstleap_filter:^BOOL(fileModel * model) {
        return model.isFolder && model.selected == NO;
    }];
    return NotBeSelectedFolderArray;
}

-(NSMutableArray *)selectedModelsArray{
    NSMutableArray *array = [self.dataSourceArray firstleap_filter:^BOOL(fileModel *model) {
        return model.selected == YES;
    }].mutableCopy;
    return array;
}

//选择所以fileModel，包括文件夹里面的model;
-(NSMutableArray *)selectedModelsArrayWithFolder{
    
    NSArray *array = [self selectedModelsArray].copy;

    NSMutableArray *allFileModels = [[NSMutableArray alloc] initWithCapacity:0];

    [self getAllSubFolderModels:allFileModels andSelectedModel:array];
    
    return allFileModels;
}

-(void)getAllSubFolderModels:(NSMutableArray *)allArray andSelectedModel:(NSArray *)selectedArray{
    
    for (fileModel *model in selectedArray) {
        
        if (model.isFolder) {
            NSArray *subsArray = [[FolderFileManager shareInstance] getAllFileModelInDic:model.fullPath];
            [self getAllSubFolderModels:allArray andSelectedModel:subsArray];
        }else{
            [allArray addObject:model];
        }
    }
}


-(void)selectedAllModel{
    self.dataSourceArray = [self.dataSourceArray firstleap_map:^fileModel *(fileModel *model) {
        model.selected = YES;
        return model;
    }].mutableCopy;
    [self.collectionView reloadData];
}

-(void)resertAllModel{
    self.dataSourceArray = [self.dataSourceArray firstleap_map:^fileModel *(fileModel *model) {
        model.selected = NO;
        return model;
    }].mutableCopy;
    [self.collectionView reloadData];
}

-(void)goDownUpTabbar{
    
    [UIView animateWithDuration:0.15 animations:^{
        self.tabBarController.tabBar.y = self.selected ?kScreenHeight:(kScreenHeight-49);
        
    } completion:^(BOOL finished) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).mas_offset(self.selected ? -49 : 0);
        }];
        [self.view layoutIfNeeded];
    }];
}

-(void)goUpEditHomeBarView{
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.editTarView setHomeBarIsHidden:!self.selected];
        [self.editTarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.selected ? (kScreenHeight - 49) : kScreenHeight);
        }];
        [self.view layoutIfNeeded];
    }];
}


-(void)addFolderText:(UIButton *)sender{
    
    NSArray *actionArray = @[@{@"文本":@(0)},@{@"文件夹":@(0)},@{@"取消":@(1)}];
    
    EasyAlertView *alert = [[EasyAlertView alloc] initWithType:AlertViewSheet andTitle:@"选择创建类型" andActionArray:actionArray andActionBlock:^(NSString *title, NSInteger index,NSArray *textFieldArray) {
        
        if (index == 0) {
            [self AddFolderOrTextWithType:1];
        }
        if (index == 1) {
            [self AddFolderOrTextWithType:0];
        }
    }];
    
    [alert showInViewController:self];
}

-(void)AddFolderOrTextWithType:(int)type{
    
    NSString *title = type == 0 ? @"创建文件夹":@"创建文本";
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSString *name = type == 0 ? @"文件夹名字":@"文本名字";
        textField.placeholder = name;
    }];
    UIAlertAction *sureAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *baseDir = self.isPushSelf ? self.model.fullPath : [[FolderFileManager shareInstance] getUploadPath];
        if (type == 0) {
            NSString *createDir = [baseDir stringByAppendingPathComponent:alertCon.textFields.firstObject.text];
            [[FolderFileManager shareInstance] createDirWithPath:createDir];
        }
        else{
            NSString *createTxtPath = [baseDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",alertCon.textFields.firstObject.text]];
            [[FolderFileManager shareInstance] createTextWithPath:createTxtPath];
        }
        [self fileFinishAndReloadTable];
        
    }];
    UIAlertAction *cancleAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:sureAc];
    [alertCon addAction:cancleAc];
    
    [self presentViewController:alertCon animated:YES completion:nil];

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
    if (self.selected) {
        
        static NSString *identify = @"SelectedFolderCell";
        SelectedFolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (self.dataSourceArray.count >0) {
            cell.model = [self.dataSourceArray objectAtIndex:indexPath.row];
        }
        return cell;

    }else{
        static NSString *identify = @"FolderCell";
        FolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (self.dataSourceArray.count >0) {
            cell.model = [self.dataSourceArray objectAtIndex:indexPath.row];
        }
        cell.delegate = self;
        cell.textView.userInteractionEnabled = NO;
        return cell;
    }

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selected && self.dataSourceArray.count > 0) {
        fileModel *model = _dataSourceArray[indexPath.row];
        model.selected = !model.selected;
        NSIndexPath *path =[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self.editTarView setHomeBarIsHidden:YES];
        return;
    }
    if (_dataSourceArray.count > 0) {
        fileModel *model = _dataSourceArray[indexPath.row];
        if (model.isFolder) {
            HomeFolderViewController *vc = [[HomeFolderViewController alloc] init];
            vc.model = model;
            vc.isPushSelf = YES;
            APPNavPushViewController(vc);
            return;
        }
        if ([SupportZIPARRAY containsObject:[model.fileType uppercaseString]]) {
            [self unZipFileWithPath:model.fullPath];
        }else{
         [self openVCWithModel:model];
        }
    }
}
#pragma mark -----FolderCellDelegate

-(void)folderCellLongPressWithModel:(fileModel *)model{
    
    NSArray *actionArray;
    
    if ([SupportVideoArray containsObject:model.fileType.uppercaseString] || [SupportPictureArray containsObject:model.fileType.uppercaseString]) {
        actionArray = @[@{@"移动至-》":@(0)},@{@"收藏":@(0)},@{@"保存到相册":@"0"},@{@"删除":@(2)},@{@"取消":@(1)}];
    }else{
        actionArray = @[@{@"移动至-》":@(0)},@{@"收藏":@(0)},@{@"删除":@(2)},@{@"取消":@(1)}];
    }
    
    EasyAlertView *alert = [[EasyAlertView alloc] initWithType:AlertViewSheet andTitle:@"选择编辑方式" andActionArray:actionArray andActionBlock:^(NSString *title, NSInteger index,NSArray *textFieldArray) {
        if ([title isEqualToString:@"移动至-》"] ) {
            [self presentMoveFolderViewController:model];
        }
        if ([title isEqualToString:@"收藏"]) {
            BOOL success =  [[FMDBTool shareInstance] addCollectionModel:model];
            if (success) {
                [self showSuccess];
            }else{
                [self showError];
            }
        }
        if ([title isEqualToString:@"删除"]) {
            [[FolderFileManager shareInstance] moveToRecyleFolderFromPath:model.fullPath];
            [self fileFinishAndReloadTable];
        }
        if ([title isEqualToString:@"保存到相册"]) {
            if (model.isVideo) {
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(model.fullPath)) {
                    //保存相册核心代码
                    UISaveVideoAtPathToSavedPhotosAlbum(model.fullPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }
            if (model.isPhoto) {
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:model.fullPath];
                 UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    }];
    [alert showInViewController:self];
}

#pragma mark ------保存视频和图片到相册

//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo
{
    if ([error isKindOfClass:[NSNull class]]) {
        [self showError];
    }
    else {
        [self showSuccess];
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [self showError];
    }else{
        [self showSuccess];
    }
}

-(void)presentMoveFolderViewController:(fileModel *)model{
    
    MoveFolderViewController *moveF = [[MoveFolderViewController alloc] init];
    moveF.isCopyFile = NO;
    moveF.selectedModelArray = @[model];
    NSArray *noselectedArray = [self theFolderNoSelected];
    if (model.isFolder) {
        noselectedArray = [noselectedArray firstleap_filter:^BOOL(fileModel *selectedModel) {
            return ![selectedModel.name isEqualToString:model.name];
        }];
    }
    moveF.notSelectedFolderArray = noselectedArray;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:moveF];
    APPPresentViewController(nav);
}

/**
 解压到当前文件夹

 @param path 需要解压的文件路径
 */
-(void)unZipFileWithPath:(NSString *)path{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = @"unziping...";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *destinationPath = [path stringByDeletingLastPathComponent];
        [SSZipArchive unzipFileAtPath:path toDestination:destinationPath delegate:self];
    });
    
}
#pragma mark ---SSZipArchiveDelegate

-(void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo{
   
}
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"finishzip");
        [self hidenMessage];
        [self fileFinishAndReloadTable];
    });
}
- (void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total{
    
    float progress = loaded / (float)total;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD HUDForView:self.view].progress = progress;
    });
}

-(void)fileFinishAndReloadTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSourceArray removeAllObjects];
        NSArray *allFiles = self.isPushSelf ? [[FolderFileManager shareInstance] getAllFileModelInDic:self.model.fullPath]:[[ResourceFileManager shareInstance] getAllUploadAllFileModels];
        [self.dataSourceArray addObjectsFromArray:allFiles];
        [self.collectionView reloadData];
        // 如果正在编辑的状态下，恢复原始;
        if (self.selected) {
            [self editClick:self.editItem];
        }
    });
}

@end

