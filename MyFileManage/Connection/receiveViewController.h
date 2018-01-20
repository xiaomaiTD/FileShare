//
//  receiveViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BaseViewController.h"
#import "UdpServerManager.h"
#import "HTTPServer.h"

@interface receiveViewController : BaseViewController{
    NSTimer *_timer;
    UInt64 currentDataLength;
}

@property (strong, nonatomic) HTTPServer *httpserver;
@property (nonatomic,strong) UdpServerManager *clientManger;

@end
