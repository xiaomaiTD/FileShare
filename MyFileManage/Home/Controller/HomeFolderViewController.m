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
//Video
#import "playVideoViewController.h"
//MUsic
#import "MusicViewController.h"

//IMAGE
#import "openImageViewController.h"
//TXT
#import "LSYReadPageViewController.h"
#import "OpenTXTEditViewController.h"
#import "LSYReadModel.h"
// PDF
#import "PDFDocument.h"
#import "PDFDocumentViewController.h"

//HTML && OA
#import "LoadWebViewController.h"

#import "MoveFolderViewController.h"
#import "senderViewController.h"

#import "ResourceFileManager.h"
#import "FolderFileManager.h"
#import "GloablVarManager.h"
#import "DataBaseTool.h"

#import "SelectedFolderCell.h"
#import "HomeToolBarView.h"
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
    
    if (self.isPushSelf) {
        self.dataSourceArray = [[[FolderFileManager shareInstance] getAllFileModelInDic:self.model.fullPath] mutableCopy];
    }else{
        NSArray *tempArray = [[ResourceFileManager shareInstance] getAllUploadAllFileModels];
        self.dataSourceArray = [tempArray mutableCopy];
    }
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
    [self.collectionView registerClass:[FolderCell class] forCellWithReuseIdentifier:@"FolderCell"];
    [self.collectionView registerClass:[SelectedFolderCell class] forCellWithReuseIdentifier:@"SelectedFolderCell"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
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
//
//    [self.editTarView.shareBtn addTargetWithBlock:^(UIButton *sender) {
//
//    }];
//
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

-(void)deleteSelectedModelArray{
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"是否删除该文件？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *folderAc = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *selectedArray = [self selectedModelsArray];
        for (fileModel *model in selectedArray) {
            [[FolderFileManager shareInstance] moveToRecyleFolderFromPath:model.fullPath];
        }
        [self fileFinishAndReloadTable];
    }];
    [alertCon addAction:folderAc];
    
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:cancelAc];
    
    [self presentViewController:alertCon animated:YES completion:nil];

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
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [editBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
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
        [self.leftItem setDefont:15];
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
    [self.leftItem setTitleColor:MAINCOLOR];
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
            make.bottom.equalTo(self.view).mas_offset(self.selected ? 49 : 0);
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
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选择创建类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *textAc = [UIAlertAction actionWithTitle:@"文本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self AddFolderOrTextWithType:1];
    }];
    UIAlertAction *folderAc = [UIAlertAction actionWithTitle:@"文件夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self AddFolderOrTextWithType:0];
    }];
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alertCon addAction:textAc];
    [alertCon addAction:folderAc];
    [alertCon addAction:cancelAc];
    [self presentViewController:alertCon animated:YES completion:nil];
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
        cell.textView.editable = NO;
        cell.textView.userInteractionEnabled = NO;
        return cell;

    }else{
        static NSString *identify = @"FolderCell";
        FolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (self.dataSourceArray.count >0) {
            cell.model = [self.dataSourceArray objectAtIndex:indexPath.row];
        }
        cell.delegate = self;
        cell.textView.editable = NO;
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
        [self.collectionView reloadData];
        [self.editTarView setHomeBarIsHidden:YES];
        return;
    }
    if (_dataSourceArray.count > 0) {
        fileModel *model = _dataSourceArray[indexPath.row];
        NSLog(@"fullPath-------%@",model.fullPath);
        if (model.isFolder) {
            HomeFolderViewController *vc = [[HomeFolderViewController alloc] init];
            vc.model = model;
            vc.isPushSelf = YES;
            APPNavPushViewController(vc);
            return;
        }
        if ([SupportPictureArray containsObject:[model.fileType uppercaseString]]) {
            openImageViewController *vc = [[openImageViewController alloc] init];
            vc.model = model;
            APPNavPushViewController(vc);
        }
        if ([SupportVideoArray containsObject:[model.fileType uppercaseString]]) {
            playVideoViewController *vc = [[playVideoViewController alloc] init];
            vc.model = model;
            APPPresentViewController(vc);
        }
        if ([SupportMusicArray containsObject:[model.fileType uppercaseString]]) {
            [self presentMusicViewController:model];
        }
        if ([model.fileType.uppercaseString isEqualToString:@"PDF"]) {
            [self presentPDFViewController:model];
        }
        if ([SupportOAArray containsObject:[model.fileType uppercaseString]]) {
            LoadWebViewController *webView = [[LoadWebViewController alloc] init];
            webView.model = model;
            APPNavPushViewController(webView);
        }
        if ([SupportTXTArray containsObject:[model.fileType uppercaseString]]) {
            [self openTXTWithModel:model];
        }
        if ([SupportZIPARRAY containsObject:[model.fileType uppercaseString]]) {
            [self unZipFileWithPath:model.fullPath];
        }
    }
}

#pragma mark -----FolderCellDelegate

-(void)folderCellLongPressWithModel:(fileModel *)model{
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选择编辑方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *textAc = [UIAlertAction actionWithTitle:@"移动至-》" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentMoveFolderViewController:model];
    }];
    [alertCon addAction:textAc];
  
    UIAlertAction *folderAc = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[FolderFileManager shareInstance] moveToRecyleFolderFromPath:model.fullPath];
        [self fileFinishAndReloadTable];
    }];
    [alertCon addAction:folderAc];
    
    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:cancelAc];
    
    [self presentViewController:alertCon animated:YES completion:nil];
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

-(void)openTXTWithModel:(fileModel *)model{
  
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选择阅读方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
    UIAlertAction *openReadAc = [UIAlertAction actionWithTitle:@"小说阅读方式打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentNovelViewControllerWithModel:model];
    }];
    [alertCon addAction:openReadAc];
  
    UIAlertAction *openTXTAc = [UIAlertAction actionWithTitle:@"文本编辑方式打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentTXTEditViewControllerWithModel:model];
    }];
    [alertCon addAction:openTXTAc];
    
    UIAlertAction *cancleAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:cancleAC];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}

/**
 文本方式打开

 @param model model
 */
-(void)presentTXTEditViewControllerWithModel:(fileModel *)model{
    
    OpenTXTEditViewController *txtVC = [[OpenTXTEditViewController alloc] init];
    txtVC.model = model;
    NSURL *txtFull = [NSURL fileURLWithPath:model.fullPath];
    [GCDQueue executeInGlobalQueue:^{
        LSYReadModel *readModel = [LSYReadModel getLocalModelWithURL:txtFull];
        txtVC.readModel = readModel;
        [GCDQueue executeInMainQueue:^{
            APPNavPushViewController(txtVC);
        }];
    }];
}

/**
 小说阅读方式打开

 @param model model
 */
-(void)presentNovelViewControllerWithModel:(fileModel *)model{
    
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *txtFull = [NSURL fileURLWithPath:model.fullPath];
    pageView.resourceURL = txtFull;
    //文件位置
    [GCDQueue executeInGlobalQueue:^{
        LSYReadModel *readModel = [LSYReadModel getLocalModelWithURL:txtFull];
        pageView.model = readModel;
        [GCDQueue executeInMainQueue:^{
             APPPresentViewController(pageView);
        }];
    }];
}

-(void)presentMusicViewController:(fileModel *)model{
    
    MusicViewController *musicVC = [MusicViewController sharedInstance];
    musicVC.musicEntities = [ResourceFileManager shareInstance].musicEntities;
    musicVC.musicTitle = model.fileName;
    APPPresentViewController(musicVC);
}

-(void)presentPDFViewController:(fileModel *)model{
    [self showMessageWithTitle:@"正在加载.."];
    [GCDQueue executeInGlobalQueue:^{
        PDFDocument *doument = [[ResourceFileManager shareInstance].documentStore documentAtPath:model.fullPath];
        NSString *storyboardName = IsPhone() ? @"MainStoryboard_iPhone":@"MainStoryboard_iPad";
        PDFDocumentViewController *vc = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:@"StoryboardPDFDocument"];
        vc.document = doument;
        [doument.store addHistory:doument];
        [GCDQueue executeInMainQueue:^{
            [self hidenMessage];
            APPNavPushViewController(vc);
        }];
    }];
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

