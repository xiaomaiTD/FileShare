//
//  HomeToolBarView.h
//  MyFileManage
//
//  Created by Viterbi on 2018/3/15.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeToolBarView : UIView

// 将所选项目移动 复制 删除 发送 分享（隔空投送）
@property(nonatomic,strong)UIButton *moveBtn;
@property(nonatomic,strong)UIButton *fuZhiBtn;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIButton *sender;

// 隐藏或者显示
-(void)setHomeBarIsHidden:(BOOL)hidden;
@end
