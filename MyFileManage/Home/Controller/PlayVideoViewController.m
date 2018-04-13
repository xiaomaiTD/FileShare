//
//  playVideoViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//
#import <MobileVLCKit/MobileVLCKit.h>

#import "Masonry.h"
#import "VideoPlayView.h"
#import "VideoCoverView.h"
#import "NSString+CHChinese.h"
#import "NSTimer+Extension.h"
#import "PlayVideoViewController.h"

@interface PlayVideoViewController ()<VLCMediaPlayerDelegate>

@property(nonatomic,strong)VLCMediaPlayer *player;
@property(nonatomic,strong)VideoPlayView *playerView;
@property(nonatomic,strong)VideoCoverView *coverView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger count;

@end

@implementation PlayVideoViewController

-(void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _coverView = [[VideoCoverView alloc] init];
    [self.view addSubview:_coverView];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTapClick)];
    [_coverView addGestureRecognizer:tap];
    
    VLCMediaPlayer *player = [[VLCMediaPlayer alloc] initWithOptions:nil];
    self.player = player;
    self.player.drawable = self.coverView;
    if (isPhonePlus()) {
        // 随意给个数值，自己适配大小。给0的话，在高清设备下，可能显示不了。
        self.player.scaleFactor = 0.5;
    }
    if (self.path) {
        self.player.media = [VLCMedia mediaWithURL:[NSURL URLWithString:self.path]];
    }else{
     self.player.media = [VLCMedia mediaWithPath:self.model.fullPath];
        
    }
    [self.player play];
    self.coverView.player = self.player;
    
    [self showMessage];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStatusChange) name:VLCMediaPlayerStateChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoProgessChange:) name:VideoSliderChange object:nil];
}

-(void)setupUI{
    
    self.playerView = [[VideoPlayView alloc] init];
    self.playerView.backgroundColor = [UIColor clearColor];
    self.playerView.player = self.player;
    [self.view addSubview:self.playerView];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(60);
    }];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"navLeft"] forState:UIControlStateNormal];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
}

-(void)coverViewAndBackBtnShowOrHidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.backBtn.alpha == 0) {
            self.backBtn.alpha = 1;
            self.playerView.alpha = 1;
        }else{
            self.backBtn.alpha = 0;
            self.playerView.alpha = 0;
        }
    } completion:nil];
}

-(void)videoTapClick{
    [self coverViewAndBackBtnShowOrHidden];
}

-(void)backBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoProgessChange:(NSNotification *)notifi{
    
    NSString *status = notifi.userInfo[@"status"];
    
    // 开始拉动进度条，就要把定时器给停止，清空数据.
    if ([status integerValue] == 0) {
        self.count = 0;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    // 进度条拖动结束，开始五秒计时；
    }else{
        if (_timer) {
            return;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
            if (self.count > 5) {
                [self coverViewAndBackBtnShowOrHidden];
                [timer invalidate];
                timer = nil;
                return ;
            }
            self.count = self.count + 1;
        } repeats:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.player) {
        [self.player pause];
        [self.player stop];
        self.player = nil;
    }
}
-(void)playStatusChange{
    if ([self.player isPlaying]) {
        [self hidenMessage];
    }
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end

