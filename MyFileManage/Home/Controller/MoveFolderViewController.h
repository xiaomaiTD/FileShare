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
@property(nonatomic,assign)BOOL isCopyFile;

@end
