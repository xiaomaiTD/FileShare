//
//  OpenImagesPageViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/4/3.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import "LocalImageAndVideoModel.h"
#import "BaseViewController.h"

@interface OpenImagesPageViewController : BaseViewController

/**
 从文件夹过来的数组
 */
@property (nonatomic, strong)NSArray *picModelArray;
/**
 从相册过来的数组
 */
@property (nonatomic, copy)NSArray *photoModelArray;

@property (nonatomic, strong)LocalImageAndVideoModel *localModel;

@end
