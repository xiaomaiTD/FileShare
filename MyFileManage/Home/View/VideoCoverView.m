//
//  VideoCoverView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/16.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "VideoCoverView.h"

@interface VideoCoverView()

@property(nonatomic,strong)UIPanGestureRecognizer *panGest;
@property(nonatomic,assign)CGFloat last_X;
@property(nonatomic,assign)CGFloat last_Y;
@property(nonatomic,assign)CGFloat playTotalTime;
@property(nonatomic,assign)CGFloat currentPlayTime;

@end

@implementation VideoCoverView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizedPlayControlRecognizer:)];
        _panGest.maximumNumberOfTouches = 1;
        _panGest.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:_panGest];
    }
    return self;
}

-(void)didRecognizedPlayControlRecognizer:(UIPanGestureRecognizer *)gester{
    
    CGPoint point = [gester locationInView:self];
    switch (gester.state) {
        case UIGestureRecognizerStateBegan:
        {
            _last_X = point.x;
            _last_Y = point.y;
            CGFloat totalTime = [self.player.time.numberValue floatValue] - [self.player.remainingTime.numberValue floatValue];
            _playTotalTime = totalTime;
            _currentPlayTime = [self.player.time.numberValue floatValue];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat offset_X = point.x - _last_X;
            CGFloat offset_Y = point.y - _last_Y;
            
            //更改进度
            if (fabs(offset_X) > fabs(offset_Y)) {
                CGFloat ration = _playTotalTime / self.width;
                CGFloat postion = offset_X ;
                CGFloat shouldMove = postion * ration;
                CGFloat shouldMoveTime = _currentPlayTime + shouldMove;
                VLCTime *time = [VLCTime timeWithNumber:[NSNumber numberWithFloat:shouldMoveTime]];
                [self.player setTime:time];
            }else{
                // 更改屏幕
                CGFloat ration = offset_Y / self.height ;
                CGFloat currentLights = [UIScreen mainScreen].brightness;
                [[UIScreen mainScreen] setBrightness:currentLights - ration];
                
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _last_X = point.x;
            _last_Y = point.y;
        }
            break;
            
        default:
            break;
    }
    
    
}

@end
