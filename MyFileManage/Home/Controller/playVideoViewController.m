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

@interface playVideoViewController ()<VLCMediaPlayerDelegate>

@property(nonatomic,strong)VLCMediaPlayer *player;

@end

@implementation playVideoViewController

-(void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:videoView];
    
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    VLCMediaPlayer *player = [[VLCMediaPlayer alloc] initWithOptions:nil];
    self.player = player;
    self.player.delegate = self;
    self.player.drawable = videoView;
    // 随意给个数值，自己适配大小。给0的话，在高清设备下，可能显示不了。
    self.player.scaleFactor = 0.5;
    self.player.media = [VLCMedia mediaWithPath:_model.fullPath];
    
    [self.player play];
    

}
-(void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    
    NSLog(@"change--------%@",self.player.media.metaDictionary);
    
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
