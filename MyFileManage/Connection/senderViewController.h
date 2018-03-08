//
//  senderViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/20.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LocalImageAndVideoModel.h"

@interface senderViewController : BaseViewController

@property(nonatomic,assign)BOOL sendImageFromAlbum;//从相册里面发送图片标识符
@property(nonatomic,strong)NSArray *imageArray;// 选中的图片数组

@end
