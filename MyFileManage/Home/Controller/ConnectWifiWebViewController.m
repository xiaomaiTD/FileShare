//
//  ConnectWifiWebViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>

#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
#import "ConnectWifiWebViewController.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface ConnectWifiWebViewController ()
@property(nonatomic,strong)UILabel *ipLable;
@property(nonatomic,strong)UIMenuController *menuController;
@end

@implementation ConnectWifiWebViewController

-(void)viewDidDisappear:(BOOL)animated{
    [httpServer stop];
    httpServer = nil;
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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(copyString)];
    longPress.minimumPressDuration = 1;
    [_ipLable addGestureRecognizer:longPress];
    
    [self createHttpServe];
        
    UIImageView *tipsImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips"]];
    tipsImagV.frame = CGRectMake(16, _ipLable.maxY + 20, 30, 30);
    [self.view addSubview:tipsImagV];
    
    UILabel *tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(tipsImagV.maxX, tipsImagV.y, kScreenWidth - tipsImagV.maxX, 40)];
    tipsLable.centerY = tipsImagV.centerY;
    tipsLable.font = [UIFont systemFontOfSize:13];
    tipsLable.numberOfLines = 0;
    tipsLable.text = @"在浏览器下敲入以上ip地址，可以将文件传输到app里面。必须确定电脑和手机连接在同一个wifi下面";
    [self.view addSubview:tipsLable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:UIMenuControllerDidHideMenuNotification object:nil];

}

-(void)createHttpServe{
    [GCDQueue executeInGlobalQueue:^{
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        httpServer = [[HTTPServer alloc] init];
        [httpServer setType:@"_http._tcp."];
        NSString *docRoot = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
        [httpServer setDocumentRoot:docRoot];
        [httpServer setConnectionClass:[MyHTTPConnection class]];
        NSError *error = nil;
        if(![httpServer start:&error])
        {
            DDLogError(@"Error starting HTTP Server: %@", error);
        }else{
            [GCDQueue executeInMainQueue:^{
                self.ipLable.text = [NSString stringWithFormat:@"%@:%hu",IPAddress(),httpServer.listeningPort];
            }];
        }
    }];
}

-(void)hideMenu{
    if (_menuController) {
        _menuController = nil;
    }
}

-(void)copyString{
    if (!_menuController) {
        _menuController = [UIMenuController sharedMenuController];
        [_menuController setTargetRect:self.ipLable.frame inView:self.view];
        [_menuController setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(cut:)){
        return NO;
    }
    else if(action == @selector(copy:)){
        return YES;
    }
    else if(action == @selector(paste:)){
        return NO;
    }
    else if(action == @selector(select:)){
        return NO;
    }
    else if(action == @selector(selectAll:)){
        return NO;
    }
    else
    {
        return [super canPerformAction:action withSender:sender];
    }
}
-(void)copy:(id)sender{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.ipLable.text;
}
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
