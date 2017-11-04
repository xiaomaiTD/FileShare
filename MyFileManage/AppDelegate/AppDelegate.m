//
//  AppDelegate.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "AppDelegate.h"

#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"

#import "MainViewController.h"


static const int ddLogLevel = LOG_LEVEL_VERBOSE;



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [MainViewController new];
    
    
    [self.window makeKeyAndVisible];
  
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    httpServer = [[HTTPServer alloc] init];
  
    [httpServer setType:@"_http._tcp."];
    NSString *docRoot = [[NSBundle mainBundle] resourcePath];
    [httpServer setDocumentRoot:docRoot];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
  
    NSError *error = nil;
    if(![httpServer start:&error])
    {
        DDLogError(@"Error starting HTTP Server: %@", error);
        
    }else{
        [[DataBaseTool shareInstance] setIPAddree:[NSString stringWithFormat:@"%d",[httpServer listeningPort]]];
    }
    return YES;
}

@end
