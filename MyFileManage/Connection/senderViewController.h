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

typedef enum : NSUInteger {
    sendImageFromAlbum = 0,//从相册发送
    sendFileFromHome,//从home页发送
    sendFileFromLocal//从快传页发送
} SendViewType;


@interface senderViewController : BaseViewController

@property(nonatomic,strong)NSArray *imageArray;// 选中的图片数组
@property(nonatomic,strong)NSArray *fileModelArray;// 选中的文件数组
@property(nonatomic,assign)SendViewType type;

@end
