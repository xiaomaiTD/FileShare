//
//  receiveViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "receiveViewController.h"
#import "MyHTTPConnection.h"
#import "NSTimer+Extension.h"

#define GBUnit 1073741824
#define MBUnit 1048576
#define KBUnit 1024


@interface receiveViewController ()

@property(nonatomic,strong)NSTimer *timer;

@end

@implementation receiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    currentDataLength = 0;
    
    self.clientManger=[[UdpServerManager alloc] init];
    [self.clientManger start];
    
    _httpserver = [[HTTPServer alloc] init];
    [_httpserver setType:@"_http._tcp."];
    [_httpserver setPort:kUDPPORT];
    NSString *webPath = [[NSBundle mainBundle] resourcePath];
    [_httpserver setDocumentRoot:webPath];
    [_httpserver setConnectionClass:[MyHTTPConnection class]];
    
   _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        [self.clientManger sendBroadcast];
       NSLog(@"sendBroadcast");
    } repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [_timer invalidate];
    _timer = nil;
    [_httpserver stop];
    _httpserver = nil;
    [_clientManger close];
    _clientManger = nil;
    
}

@end
