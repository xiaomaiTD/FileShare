//
//  LoadWebViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/13.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "LoadWebViewController.h"
#import <WebKit/WebKit.h>

@interface LoadWebViewController ()<WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation LoadWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:_model.fullPath]];
    [_webView loadRequest:request];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [self showMessageWithTitle:@"正在加载..."];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self hidenMessage];
}


@end
