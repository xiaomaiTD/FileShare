//
//  ConnectWifiWebViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//
#import "FolderFileManager.h"
#import "ConnectWifiWebViewController.h"
#import <GCDWebServer/GCDWebUploader.h>

@interface ConnectWifiWebViewController ()<GCDWebUploaderDelegate>

@property(nonatomic,strong)UILabel *ipLable;
@property(nonatomic,strong)GCDWebUploader* webServer;

@end

@implementation ConnectWifiWebViewController

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_webServer stop];
    _webServer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文件共享";
    self.view.backgroundColor = [UIColor whiteColor];
    _ipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 250, 50)];
    _ipLable.centerX = self.view.width/2.0;
    _ipLable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _ipLable.layer.cornerRadius = 5;
    _ipLable.layer.masksToBounds = true;
    _ipLable.textAlignment = NSTextAlignmentCenter;
    _ipLable.userInteractionEnabled = YES;
    [self.view addSubview:_ipLable];
    
        
    UIImageView *tipsImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips"]];
    tipsImagV.frame = CGRectMake(16, _ipLable.maxY + 20, 30, 30);
    [self.view addSubview:tipsImagV];
    
    UILabel *tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(tipsImagV.maxX, tipsImagV.y, kScreenWidth - tipsImagV.maxX, 40)];
    tipsLable.centerY = tipsImagV.centerY;
    tipsLable.font = [UIFont systemFontOfSize:13];
    tipsLable.numberOfLines = 0;
    tipsLable.text = @"在浏览器下敲入以上ip地址，可以将文件传输到app里面。必须确定电脑和手机连接在同一个wifi下面";
    [self.view addSubview:tipsLable];
    
    NSString *uploadPath = [[FolderFileManager shareInstance] getUploadPath];
    
    _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:uploadPath];
    _webServer.delegate = self;
    _webServer.allowHiddenItems = YES;
    if ([_webServer start]) {
        _ipLable.text = _webServer.serverURL.absoluteString;
    } else {
        _ipLable.text = NSLocalizedString(@"GCDWebServer not running!", nil);
    }
    
}

- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    
    POSTNotificationName(FileFinish, nil);
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    POSTNotificationName(FileFinish, nil);
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    POSTNotificationName(FileFinish, nil);
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    POSTNotificationName(FileFinish, nil);
}


@end
