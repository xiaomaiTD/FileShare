//
//  BaseDealFileViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BaseDealFileViewController.h"
#import "OpenImageViewController.h"
#import "OpenImagesPageViewController.h"
#import "PlayVideoViewController.h"
#import "LoadWebViewController.h"
#import "OpenTXTEditViewController.h"
#import "LSYReadPageViewController.h"
#import "MusicViewController.h"
#import "MoveFolderViewController.h"
#import "PDFDocumentViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SSZipArchive/SSZipArchive.h>

#import "FolderFileManager.h"
#import "ResourceFileManager.h"
#import "EasyAlertView.h"
#import "PDFDocument.h"
#import "FMDBTool.h"

@interface BaseDealFileViewController ()

@end

@implementation BaseDealFileViewController

-(void)openVCWithModel:(fileModel *)model{
    
    NSLog(@"fullPath------%@",model.fullPath);
    if ([SupportPictureArray containsObject:[model.fileType uppercaseString]]) {
        OpenImagesPageViewController *vc = [[OpenImagesPageViewController alloc] init];
        vc.model = model;
        APPNavPushViewController(vc);
    }
    if ([SupportVideoArray containsObject:[model.fileType uppercaseString]]) {
        PlayVideoViewController *vc = [[PlayVideoViewController alloc] init];
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
    [[FMDBTool shareInstance] addHistoryModel:model];
}


-(void)openTXTWithModel:(fileModel *)model{
    
    
    NSArray *actionArray = @[@{@"小说阅读方式打开":@(0)},@{@"文本编辑方式打开":@(0)},@{@"取消":@"1"}];
    
    EasyAlertView *alert = [[EasyAlertView alloc] initWithType:AlertViewSheet andTitle:@"选择阅读方式" andActionArray:actionArray andActionBlock:^(NSString *title, NSInteger index,NSArray *textFieldArray) {
        
        if (index == 0) {
            [self presentNovelViewControllerWithModel:model];
        }
        if (index == 1) {
            [self presentTXTEditViewControllerWithModel:model];
        }
    }];
    [alert showInViewController:self];
    
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



@end
