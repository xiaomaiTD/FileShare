//
//  openImageViewController.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileModel.h"
#import "BaseViewController.h"
#import "LocalImageAndVideoModel.h"

@interface OpenImageViewController : BaseViewController

/**
 是否从相册过来的model
 */
@property(nonatomic,strong)LocalImageAndVideoModel *localModel;
@end
