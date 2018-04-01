//
//  MoveFolderViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/2/6.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BaseViewController.h"

@interface MoveFolderViewController : BaseViewController

@property(nonatomic,strong)NSArray *selectedModelArray;
@property(nonatomic,strong)NSArray *notSelectedFolderArray;
@property(nonatomic,assign)BOOL isCopyFile;//是否文件复制
@property(nonatomic,assign)BOOL isSelectedDowload;//是否为 选择下载跟目录

@end
