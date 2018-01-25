//
//  receiveViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "receiveViewController.h"
#import "AYHTTPConnection.h"
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
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"website"];
    [_httpserver setDocumentRoot:webPath];
    [_httpserver setConnectionClass:[AYHTTPConnection class]];
    [_httpserver start:nil];
    
    [self addObservers];
    
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
- (void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithStart:) name:UPLOADSTART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploading:) name:UPLOADING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithEnd:) name:UPLOADEND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadWithDisconnect:) name:UPLOADISCONNECTED object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveIpFinished:) name:kNotificationIPReceivedFinishd object:nil];
}
//接收到ip地址
- (void)receiveIpFinished:(NSNotification*)notifice{
    NSString *host=[notifice.userInfo objectForKey:@"host"];
    NSLog(@"host =%@",host);
    
}
#pragma mark -notification
- (void) uploadWithStart:(NSNotification *) notification
{
    UInt64 fileSize = [(NSNumber *)[notification.userInfo objectForKey:@"totalfilesize"] longLongValue];
    __block NSString *showFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (fileSize>GBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%.1fG", (CGFloat)fileSize / (CGFloat)GBUnit];
        if (fileSize>MBUnit && fileSize<=GBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%.1fMB", (CGFloat)fileSize / (CGFloat)MBUnit];
        else if (fileSize>KBUnit && fileSize<=MBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%lliKB", fileSize / KBUnit];
        else if (fileSize<=KBUnit)
            showFileSize = [[NSString alloc] initWithFormat:@"%lliB", fileSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    showFileSize = nil;
}

- (void) uploadWithEnd:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
}

- (void) uploadWithDisconnect:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentDataLength = 0;
        
    });
}

- (void) uploading:(NSNotification *)notification
{
    float value = [(NSNumber *)[notification.userInfo objectForKey:@"progressvalue"] floatValue];
    currentDataLength += [(NSNumber *)[notification.userInfo objectForKey:@"cureentvaluelength"] intValue];
    __block NSString *showCurrentFileSize = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (currentDataLength>GBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fG", (CGFloat)currentDataLength / (CGFloat)GBUnit];
        if (currentDataLength>MBUnit && currentDataLength<=GBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%.1fMB", (CGFloat)currentDataLength / (CGFloat)MBUnit];
        else if (currentDataLength>KBUnit && currentDataLength<=MBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliKB", currentDataLength / KBUnit];
        else if (currentDataLength<=KBUnit)
            showCurrentFileSize = [[NSString alloc] initWithFormat:@"%lliB", currentDataLength];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"showCurrentFileSize");
        });
    });
    NSLog(@"value------%f",value);
    showCurrentFileSize = nil;
}

@end