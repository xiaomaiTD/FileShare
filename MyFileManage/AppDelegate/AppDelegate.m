//
//  AppDelegate.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/24.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FolderFileManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MainViewController new];
    [self.window makeKeyAndVisible];
    
    // 建立系统文件夹
    [[FolderFileManager shareInstance] createSystemFolder];
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.wangchao.MyFileManageShareExtension"];
 
    if ([userDefaults boolForKey:@"has-new-pdf"]) {
        
        NSURL *url = [userDefaults objectForKey:@"share-pdf-url"];
        
        NSLog(@"url---------%@",url);
        
    }
  
  
    return YES;
}

@end
