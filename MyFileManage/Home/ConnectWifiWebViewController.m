//
//  ConnectWifiWebViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>


#import "ConnectWifiWebViewController.h"

@interface ConnectWifiWebViewController ()


@property(nonatomic,strong)UILabel *ipLable;


@end

@implementation ConnectWifiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文件共享";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _ipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 250, 50)];
    
    _ipLable.centerX = self.view.width/2.0;
    
    _ipLable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _ipLable.layer.cornerRadius = 5;
    
    _ipLable.layer.masksToBounds = true;
    
    _ipLable.text = [NSString stringWithFormat:@"%@:%@",[self getIPAddress],[[DataBaseTool shareInstance] getIpAddress]];
    
    _ipLable.textAlignment = NSTextAlignmentCenter;
    
    
    
    [self.view addSubview:_ipLable];
    
    


}

-(void)copy:(id)sender{

    
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
