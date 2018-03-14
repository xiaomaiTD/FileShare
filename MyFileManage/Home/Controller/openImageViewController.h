//
//  openImageViewController.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileModel.h"
#import "LocalImageAndVideoModel.h"

@interface openImageViewController : UIViewController

@property(nonatomic,strong)fileModel *model;
@property(nonatomic,strong)LocalImageAndVideoModel *localModel;

@end
