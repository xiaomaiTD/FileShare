//
//  homeViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "homeViewController.h"
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

#import "FloderDoumentViewController.h"

@interface homeViewController ()
<
UITableViewDelegate,UITableViewDataSource
>

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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (self.isPushSelf) {
        self.dataSourceArray = [[[FolderFileManager shareInstance] getAllFileModelInDic:self.model.fullPath] mutableCopy];
    }else{
        NSArray *tempArray = [[ResourceFileManager shareInstance] getAllUploadAllFileModels];
        if (tempArray && tempArray.count > 0 ) {
            self.dataSourceArray = tempArray.mutableCopy;
        }
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
    if (!self.isPushSelf) {
        [self configueNavItem];
    }
    // Music data

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
        NSLog(@"path-----%@",model.fullPath);
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
        if ([SupportOAArray containsObject:[model.fileType uppercaseString]]) {
            LoadWebViewController *webView = [[LoadWebViewController alloc] init];
            webView.model = model;
            [self.navigationController pushViewController:webView animated:YES];
        }
        if ([SupportTXTArray containsObject:[model.fileType uppercaseString]]) {
            [self presentTXTViewControllerWithModel:model];
        }
        //文件夹没有后缀名
        if (model.fileType.length == 0) {
            homeViewController *vc = [[homeViewController alloc] init];
            vc.model = model;
            vc.isPushSelf = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
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
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}

-(void)presentMusicViewController:(fileModel *)model{
    
    MusicViewController *musicVC = [MusicViewController sharedInstance];
    musicVC.musicEntities = [ResourceFileManager shareInstance].musicEntities;
    musicVC.musicTitle = model.fileName;
    [self presentViewController:musicVC animated:YES completion:nil];
}

-(void)presentPDFViewController:(fileModel *)model{
    
    PDFDocument *doument = [[ResourceFileManager shareInstance].documentStore documentAtPath:model.fullPath];
    NSString *storyboardName = IsPhone() ? @"MainStoryboard_iPhone":@"MainStoryboard_iPad";
    PDFDocumentViewController *vc = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:@"StoryboardPDFDocument"];
    vc.document = doument;
    [doument.store addHistory:doument];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)fileFinishAndReloadTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSourceArray removeAllObjects];
        NSArray *allFiles = [[ResourceFileManager shareInstance] getAllUploadAllFileModels];
        [self.dataSourceArray addObjectsFromArray:allFiles];
        [self.tableView reloadData];
    });
}



@end

