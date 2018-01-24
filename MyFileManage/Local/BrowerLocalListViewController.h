//
//  BrowerLocalListViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "BaseViewController.h"

@interface BrowerLocalListViewController : BaseViewController

@property(nonatomic,strong)PHAssetCollection *assetCollection;
@property(nonatomic,strong)PHFetchResult *fetResult;

@end
