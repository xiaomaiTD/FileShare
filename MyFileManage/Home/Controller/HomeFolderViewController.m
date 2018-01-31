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

#import "HomeFolderViewController.h"
#import "ConnectWifiWebViewController.h"
//Video
#import "playVideoViewController.h"
//MUsic
#import "MusicViewController.h"

//IMAGE
#import "openImageViewController.h"
//TXT
#import "LSYReadPageViewController.h"
#import "LSYReadModel.h"
// PDF
#import "PDFDocument.h"
#import "PDFDocumentViewController.h"

//HTML && OA
#import "LoadWebViewController.h"

#import "ResourceFileManager.h"
#import "FolderFileManager.h"
#import "GloablVarManager.h"

#import "FolderCell.h"
#import "GCD.h"

@interface HomeFolderViewController ()
<
UICollectionViewDelegate,UICollectionViewDataSource,SSZipArchiveDelegate
>

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)FBKVOController *KVOController;

@end

@implementation HomeFolderViewController

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
        if (tempArray && tempArray.count > 0 ) {
            self.dataSourceArray = tempArray.mutableCopy;
        }
    }
    if (!self.isPushSelf) {
        [self configueNavItem];
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
    [self.collectionView registerClass:[FolderCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileFinishAndReloadTable) name:FileFinish object:nil];
    // 监听 
    [self addKVO];
}

-(void)addKVO{
    
    FBKVOController *KVOController = [FBKVOController controllerWithObserver:self];
    self.KVOController = KVOController;
    // 是否显示隐藏文件夹
    [self.KVOController observe:[GloablVarManager shareManager] keyPath:@"showHiddenFolder" options: NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"change------%@",change);
        NSLog(@"observer------%@",observer);
        NSLog(@"object------%@",object);
    }];
    // 显示文件后缀
    [self.KVOController observe:[GloablVarManager shareManager] keyPath:@"showFolderType" options: NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"change------%@",change);
        NSLog(@"observer------%@",observer);
        NSLog(@"object------%@",object);
    }];
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
        NSLog(@"path-----%@",model.fullPath);
        NSLog(@"path-----%@",model.fileType);
        //如果是文件夹
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
            [self presentTXTViewControllerWithModel:model];
        }
        if ([SupportZIPARRAY containsObject:[model.fileType uppercaseString]]) {
            [self unZipFileWithPath:model.fullPath];
        }
    }
    
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

-(void)presentTXTViewControllerWithModel:(fileModel *)model{
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *txtFull = [NSURL fileURLWithPath:model.fullPath];
    pageView.resourceURL = txtFull;
    //文件位置
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        LSYReadModel *readModel = [LSYReadModel getLocalModelWithURL:txtFull];
        pageView.model = readModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            APPPresentViewController(pageView);
        });
    });
}

-(void)presentMusicViewController:(fileModel *)model{
    
    MusicViewController *musicVC = [MusicViewController sharedInstance];
    musicVC.musicEntities = [ResourceFileManager shareInstance].musicEntities;
    musicVC.musicTitle = model.fileName;
    APPPresentViewController(musicVC);
}

-(void)presentPDFViewController:(fileModel *)model{
    
    PDFDocument *doument = [[ResourceFileManager shareInstance].documentStore documentAtPath:model.fullPath];
    NSString *storyboardName = IsPhone() ? @"MainStoryboard_iPhone":@"MainStoryboard_iPad";
    PDFDocumentViewController *vc = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:@"StoryboardPDFDocument"];
    vc.document = doument;
    [doument.store addHistory:doument];
    APPNavPushViewController(vc);
}

-(void)fileFinishAndReloadTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSourceArray removeAllObjects];
        NSArray *allFiles = self.isPushSelf ? [[FolderFileManager shareInstance] getAllFileModelInDic:self.model.fullPath]:[[ResourceFileManager shareInstance] getAllUploadAllFileModels];
        [self.dataSourceArray addObjectsFromArray:allFiles];
        [self.collectionView reloadData];
    });

}



@end

