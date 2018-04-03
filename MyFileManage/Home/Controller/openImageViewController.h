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

/**
 是否从文件过来的model
 */
@property(nonatomic,strong)fileModel *model;

/**
 是否从相册过来的model
 */
@property(nonatomic,strong)LocalImageAndVideoModel *localModel;
@end
