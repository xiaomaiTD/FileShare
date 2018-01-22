//
//  sendFileViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/22.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class fileModel;

@protocol senderFileViewControllerDelegate<NSObject>

@optional
-(void)senderFileSelectedModel:(fileModel *)model;

@end

@interface sendFileViewController : BaseViewController
@property(nonatomic,assign)BOOL isPushSelf;
@property(nonatomic,strong)fileModel *model;
@property(nonatomic,weak)id<senderFileViewControllerDelegate>delegate;

@end
