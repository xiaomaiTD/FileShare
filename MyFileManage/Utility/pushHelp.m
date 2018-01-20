//
//  firstleapC.c
//  firstleapKit
//
//  Created by Viterbi on 2017/10/13.
//  Copyright © 2017年 firstLeap. All rights reserved.
//

#include "pushHelp.h"

void APPNavPushViewController(UIViewController *vc)
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UINavigationController *navc = [(UITabBarController *)rootVC selectedViewController];
        [navc pushViewController:vc animated:YES];
    }
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootVC pushViewController:vc animated:YES];
    }
}

void APPPopViewController(UIViewController *vc){
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UINavigationController *navc = [(UITabBarController *)rootVC selectedViewController];
        [navc popToViewController:vc animated:YES];
    }
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        [rootVC.navigationController popToViewController:vc animated:YES];
    }
    
}

UIViewController* getCurrentVCFrom(UIViewController *rootVC){
    
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        currentVC = getCurrentVCFrom([(UITabBarController *)rootVC selectedViewController]);
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        
        currentVC = getCurrentVCFrom([(UINavigationController *)rootVC visibleViewController]);
        
    } else {
        currentVC = rootVC;
    }
    return currentVC;
}

UIViewController* getCurrentVC(){
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = getCurrentVCFrom(rootViewController);
    return currentVC;
}

/**
 presnt控制器

 @param vc 需要推的控制器
 */
void APPPresentViewController(UIViewController *vc){
    
    UIViewController *currentVc = getCurrentVC();
    [currentVc presentViewController:vc animated:YES completion:nil];
}

void APPdismissViewController(UIViewController *vc)
{
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}



