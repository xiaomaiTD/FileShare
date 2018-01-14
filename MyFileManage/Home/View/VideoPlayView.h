//
//  VideoPlayView.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/14.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileModel.h"

@interface VideoPlayView : UIView

@property(nonatomic,strong)fileModel *model;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)NSString *titleLable;

@end
