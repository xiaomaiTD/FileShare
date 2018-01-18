//
//  homeViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "homeViewController.h"
#import "ConnectWifiWebViewController.h"
#import "fileModel.h"
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
#import "PDFDocumentStore.h"
#import "PDFDocument.h"
#import "PDFDocumentViewController.h"

//HTML
#import "LoadWebViewController.h"

@interface homeViewController ()
<
UITableViewDelegate,UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *musicEntities;
@property(nonatomic,strong)PDFDocumentStore *documentStore;

@end

@implementation homeViewController

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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSArray *tempArray = [self getAllUploadAllFileModels];
    if (tempArray && tempArray.count > 0 ) {
        self.dataSourceArray = tempArray.mutableCopy;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
    }];
    
    [self configueNavItem];
    
    // Music data
    self.musicEntities = [MusicEntity arrayOfEntitiesFromArray:[self getAllUploadMusicDic]].mutableCopy;
    //PDF data
    self.documentStore = [[PDFDocumentStore alloc] init];
    
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
    }
    if (_dataSourceArray.count > 0) {
        fileModel *model = _dataSourceArray[indexPath.row];
        cell.textLabel.text = model.fileName;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataSourceArray.count > 0) {
        
        fileModel *model = _dataSourceArray[indexPath.row];
        NSLog(@"fullpath----------%@",model.fullPath);
        if ([SupportPictureArray containsObject:[model.fileType uppercaseString]]) {
            openImageViewController *vc = [[openImageViewController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([SupportVideoArray containsObject:[model.fileType uppercaseString]]) {
            playVideoViewController *vc = [[playVideoViewController alloc] init];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        }
        if ([SupportMusicArray containsObject:[model.fileType uppercaseString]]) {
            [self presentMusicViewController:model];
        }
        if ([model.fileType.uppercaseString isEqualToString:@"PDF"]) {

            [self presentPDFViewController:model];
        }
        if ([model.fileType.uppercaseString isEqualToString:@"HTML"]) {

            LoadWebViewController *webView = [[LoadWebViewController alloc] init];
            webView.model = model;
            [self.navigationController pushViewController:webView animated:YES];
        }
        if ([SupportTXTArray containsObject:[model.fileType uppercaseString]]) {
            LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
            NSURL *txtFull = [NSURL fileURLWithPath:model.fullPath];
            pageView.resourceURL = txtFull;
            //文件位置
        dispatch_async(dispatch_get_global_queue(0,0), ^{
                LSYReadModel *readModel = [LSYReadModel getLocalModelWithURL:txtFull];
                pageView.model = readModel;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:pageView animated:YES completion:nil];
                });
            });
        }
    }
}

-(void)presentMusicViewController:(fileModel *)model{
    
    MusicViewController *musicVC = [MusicViewController sharedInstance];
    musicVC.musicEntities = _musicEntities;
    musicVC.musicTitle = model.fileName;
    [self presentViewController:musicVC animated:YES completion:nil];
}

-(void)presentPDFViewController:(fileModel *)model{
    
    PDFDocument *doument = [self.documentStore documentAtPath:model.fullPath];
    NSString *storyboardName = IsPhone() ? @"MainStoryboard_iPhone":@"MainStoryboard_iPad";
    PDFDocumentViewController *vc = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:@"StoryboardPDFDocument"];
    vc.document = doument;
    [doument.store addHistory:doument];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}


-(void)fileFinishAndReloadTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSourceArray removeAllObjects];
        NSArray *allFiles = [self getAllUploadAllFileModels];
        [self.dataSourceArray addObjectsFromArray:allFiles];
        [self.tableView reloadData];
    });
}


/**
 构造 音乐列表字典

 @return array
 */
- (NSArray *) getAllUploadMusicDic
{
   NSArray *fileModelArray =  [[[[self getAllFilesName] firstleap_filter:^BOOL(NSString *obj) {
        return [obj hasSuffix:@"mp3"];
    }] firstleap_map:^NSDictionary * ( NSString *fileString) {
    
        NSString *fileName = [fileString stringByDeletingPathExtension];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@",FileUploadSavePath,fileString];
        NSDictionary *musicDic = @{@"name":fileName,
                                   @"fileName":fileName,
                                   @"fullPath":fullPath
                                   };
        return musicDic;
    }] copy];
    
    return fileModelArray;
}

/**
 获取所有file model

 @return array
 */
- (NSArray *) getAllUploadAllFileModels
{
    NSArray *fileModelArray = [[[self getAllFilesName] firstleap_filter:^BOOL(NSString *files) {
        return ![files isEqualToString:@".DS_Store"];
    }] firstleap_map:^fileModel *(NSString *files) {
        return [[fileModel alloc] initWithFileString:files];
    }];
    return fileModelArray;
}


/**
 获取 MyFileManageUpload 文件夹下的所有文件名字

 @return 文件数组
 */
-(NSArray *)getAllFilesName{
    
    NSString *uploadDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    uploadDirPath = [NSString stringWithFormat:@"%@/MyFileManageUpload",uploadDirPath];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:uploadDirPath error:nil];
    return files;
}

@end

