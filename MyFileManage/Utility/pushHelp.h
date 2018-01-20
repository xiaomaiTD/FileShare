//
//  firstleapC.h
//  firstleapKit
//
//  Created by Viterbi on 2017/10/13.
//  Copyright © 2017年 firstLeap. All rights reserved.
//

//#ifndef firstleapC_h
//#define firstleapC_h

#include <stdio.h>
#import <UIKit/UIKit.h>

//#ifdef __cplusplus
//#define FP_EXTERN_C_BEGIN  extern "C" {
//#define FP_EXTERN_C_END  }
//#else
//#define FP_EXTERN_C_BEGIN
//#define FP_EXTERN_C_END
//#endif

//FP_EXTERN_C_BEGIN


/**
 需要PUSH的控制权
 @param vc 控制器
 */
void APPNavPushViewController(UIViewController *vc);
void APPPopViewController(UIViewController *vc);

/**
 需要Present的控制权
 @param vc 控制器
 */
void APPPresentViewController(UIViewController *vc);
void APPdismissViewController(UIViewController *vc);


//FP_EXTERN_C_END




//#endif /* firstleapC_h */

