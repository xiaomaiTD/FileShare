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
    UINavigationController *navc = nil;
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        navc = [(UITabBarController *)rootVC selectedViewController];
    }
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        navc = (UINavigationController *)rootVC;
    }
     [navc pushViewController:vc animated:YES];
}

void APPPopViewController(Class cla){
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navc = nil;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        navc = [(UITabBarController *)rootVC selectedViewController];
    }
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        navc = (UINavigationController *)rootVC;
    }
    for (UIViewController *selectedVC in navc.viewControllers) {
        NSLog(@"class=======%@",[selectedVC class]);
        if ([selectedVC isKindOfClass:cla]) {
            [navc popToViewController:selectedVC animated:YES];
            break;
        }
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



