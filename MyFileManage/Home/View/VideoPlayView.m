//
//  VideoPlayView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/14.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "VideoPlayView.h"

@interface VideoPlayView()<VLCMediaPlayerDelegate>

@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,copy)NSString *totalTime;
@property(nonatomic,assign)double totalTimeNumber;

@end

@implementation VideoPlayView

- (instancetype)initWithFrame:(CGRect)frame
    {
    self = [super initWithFrame:frame];
    if (self) {
        _isFirst = YES;
        [self setUpPlayControl];
    }
    return self;
}

-(void)setUpPlayControl{
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.slider = [[QMUISlider alloc] init];
    self.slider.value = 0;
    self.slider.minimumTrackTintColor = MAINCOLOR;
    self.slider.maximumTrackTintColor = [UIColor whiteColor];
    self.slider.trackHeight = 1;
    self.slider.thumbColor = MAINCOLOR;
    self.slider.thumbSize = CGSizeMake(14, 14);
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderBegin:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.slider];
    
    self.timeLable = [[UILabel alloc] init];
    self.timeLable.text = @"--:--:--/--:--:--";
    self.timeLable.font = [UIFont systemFontOfSize:11];
    self.timeLable.textColor = [UIColor whiteColor];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLable];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_right).offset(10);
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(self.playButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLable.mas_left).offset(-10);
        make.left.equalTo(self.playButton.mas_right).offset(10);
        make.centerY.equalTo(self.playButton.mas_centerY);
    }];
    
}

-(void)playButtonClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    sender.isSelected ? [self.player pause] : [self.player play];
}
-(void)sliderBegin:(QMUISlider *)slider{
    if ([self.player canPause]) {
        [self.player pause];
    }
    NSDictionary *status = @{@"status":@"0"};
    POSTNotificationName(VideoSliderChange, status);
}
-(void)sliderValueChange:(QMUISlider *)slider{
    
    [self.player setPosition:slider.value];
}
-(void)sliderEnd:(QMUISlider *)slider{
    [self.player play];
    NSDictionary *status = @{@"status":@"1"};
    POSTNotificationName(VideoSliderChange, status);
}

#pragma mark -- VLCMediaPlayerDelegate
-(void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    
}

-(void)mediaPlayerTimeChanged:(NSNotification *)aNotification{

    if (self.player.remainingTime.numberValue != nil && self.isFirst) {
        self.totalTime = [self.player.remainingTime.stringValue substringFromIndex:1];
        self.isFirst = NO;
        self.totalTimeNumber = -[self.player.remainingTime.numberValue doubleValue];
    }
    if (self.player.remainingTime.numberValue != nil) {
        self.timeLable.text = [NSString stringWithFormat:@"%@/%@",self.player.time.stringValue,self.totalTime];
        self.slider.value = 1 + [self.player.remainingTime.numberValue doubleValue] / self.totalTimeNumber;
    }
    
}

#pragma mark --- player set
-(void)setPlayer:(VLCMediaPlayer *)player{
    if (_player != player) {
        _player = player;
        _player.delegate = self;
    }
}

@end

