//
//  SMBBrowListViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/4/12.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BaseViewController.h"
#import <SMBClient/SMBClient.h>

@interface SMBBrowListViewController : BaseViewController

@property(nonatomic,strong)SMBFileServer *fileServer;
@property(nonatomic,strong)SMBShare *share;
@property(nonatomic,strong)SMBFile *file;

@end
