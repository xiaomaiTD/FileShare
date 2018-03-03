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
#import "receiveFileView.h"

#define GBUnit 1073741824
#define MBUnit 1048576
#define KBUnit 1024


@interface receiveViewController ()

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIScrollView *contenScrollView;
@property(nonatomic,strong)UIView *containerView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *viewArray;
@property(nonatomic,strong)UIActivityIndicatorView *indicator;

@end

@implementation receiveViewController

-(NSMutableArray *)dataSourceArray{
  if (_dataSourceArray == nil) {
    _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
  }
  return _dataSourceArray;
}

-(NSMutableArray *)viewArray{
    if (_viewArray == nil) {
        _viewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _viewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
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
       
    } repeats:YES];
    
    self.title = [NSString stringWithFormat:@"本机ip：%@",IPAddress()];
    [self setRightItem];
}


-(void)setRightItem{
    
    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.hidesWhenStopped = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicator];
    [self.indicator startAnimating];
}

-(void)setUI{
    
    [self.contenScrollView removeFromSuperview];
    self.contenScrollView = nil;
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    if (self.viewArray.count > 0) {
        for (UIView *view in self.viewArray) {
            [view removeFromSuperview];
        }
    }
    [self.viewArray removeAllObjects];

    self.contenScrollView= [UIScrollView new];
    self.contenScrollView.backgroundColor = [UIColor whiteColor];
    self.contenScrollView.layer.masksToBounds = YES;
    self.contenScrollView.layer.cornerRadius = 5;
    [self.view addSubview:self.contenScrollView];
    [self.contenScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64,5,5,5));
    }];
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contenScrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contenScrollView);
        make.width.equalTo(self.contenScrollView);
    }];
    
    NSInteger count = self.dataSourceArray.count;
    
    UIView *lastView = nil;
    
    for ( int i = 0 ; i < count ; i++ )
    {
        receiveFileView *subv = [receiveFileView new];
        subv.fileName = self.dataSourceArray[i][@"filename"];
        [self.containerView addSubview:subv];
        [self.viewArray addObject:subv];
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.containerView);
            make.height.mas_equalTo(@(60));
            if ( lastView )
            {
                make.top.mas_equalTo(lastView.mas_bottom);
            }
            else
            {
                make.top.mas_equalTo(self.containerView.mas_top);
            }
        }];
        
        lastView = subv;
    }
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (lastView.maxY < kScreenHeight) {
            make.height.mas_offset(kScreenHeight);
        }else{
            make.bottom.equalTo(lastView.mas_bottom);
        }
    }];

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
    NSDictionary *info = notification.userInfo;
    NSLog(@"info-----%@",info);
    ///filename
    if (![self.dataSourceArray containsObject:info]) {
        [self.dataSourceArray addObject:info];
    }
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
    [GCDQueue executeInMainQueue:^{
       [self setUI];
    }];
}

- (void) uploadWithEnd:(NSNotification *) notification
{
    NSString *filename = notification.userInfo[@"filename"];
    for (receiveFileView *receive in self.viewArray) {
        if ([filename isEqualToString:receive.fileName]) {
            [GCDQueue executeInMainQueue:^{
                [receive updateProgressViewWithValue:1.0];
                [self showSuccess];
            }];
        }
    }
}

- (void) uploadWithDisconnect:(NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        currentDataLength = 0;
        [self showErrorWithTitle:@"网络连接断开"];
    });
}

- (void) uploading:(NSNotification *)notification
{
    float value = [(NSNumber *)[notification.userInfo objectForKey:@"progressvalue"] floatValue];
    progress = progress + value;
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
        NSLog(@"showCurrentFileSize--------%@",showCurrentFileSize);
        NSLog(@"progress-------%f",progress);
        NSString *filename = notification.userInfo[@"filename"];
        for (receiveFileView *receive in self.viewArray) {
            if ([filename isEqualToString:receive.fileName]) {
                [GCDQueue executeInMainQueue:^{
                    [receive updateProgressViewWithValue:progress];
                }];
            }
        }
        
    });
    showCurrentFileSize = nil;
    
}

@end
