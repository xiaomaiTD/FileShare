//
//  playVideoViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "playVideoViewController.h"
#import "playView.h"
#import "progressView.h"
#import "Masonry.h"
#import <MobileVLCKit/MobileVLCKit.h>

@interface playVideoViewController ()

@property(nonatomic,strong)VLCMediaPlayer *player;

@end

@implementation playVideoViewController

-(void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200)];
    [self.view addSubview:videoView];
    VLCMediaPlayer *player = [[VLCMediaPlayer alloc] initWithOptions:nil];
    self.player = player;
    self.player.drawable = videoView;
    self.player.media = [VLCMedia mediaWithPath:_model.fullPath];
    [self.player play];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player pause];
        [self.player stop];
        NSLog(@"[self.player stop];");
    });
    
}

-(void)dealloc{
    
    self.player = nil;
   
}




@end
