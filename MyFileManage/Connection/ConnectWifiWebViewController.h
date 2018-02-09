//
//  ConnectWifiWebViewController.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class HTTPServer;


@interface ConnectWifiWebViewController : BaseViewController
{
    HTTPServer *httpServer;
}

@end
