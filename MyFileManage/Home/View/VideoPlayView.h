//
//  VideoPlayView.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/14.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <MobileVLCKit/MobileVLCKit.h>
#import <QMUIKit/QMUIKit.h>

#import <UIKit/UIKit.h>
#import "fileModel.h"

typedef enum : NSUInteger {
    isPlaying,
    beStopped,
} PLAYSTATUS;

@interface VideoPlayView : UIView

@property(nonatomic,strong)fileModel *model;
@property(nonatomic,strong)NSString *titleLable;
@property(nonatomic,strong)UIButton *playButton;
@property(nonatomic,strong)QMUISlider *slider;
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)VLCMediaPlayer *player;

@end

