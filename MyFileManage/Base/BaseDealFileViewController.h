//
//  BaseDealFileViewController.h
//  MyFileManage
//
//  Created by Viterbi on 2018/3/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "BaseViewController.h"
#import "fileModel.h"

@interface BaseDealFileViewController : BaseViewController
-(void)openVCWithModel:(fileModel *)model;
@end
