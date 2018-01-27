//
//  PlayLocalVideoViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/27.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "PlayLocalVideoViewController.h"
#import "ImageManager.h"

@interface PlayLocalVideoViewController ()
@property(nonatomic,assign)BOOL navISHidden;
@property(nonatomic,strong)UIImageView *localImgV;
@property(nonatomic,strong)UIButton *playBtn;
@end

@implementation PlayLocalVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    self.view.backgroundColor = [UIColor blackColor];
    self.localImgV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.localImgV.contentMode = UIViewContentModeScaleAspectFit;
    self.localImgV.userInteractionEnabled = NO;
    [self.view addSubview:self.localImgV];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"PlayClick"] forState:UIControlStateNormal];
    [self.view addSubview:self.playBtn];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(kScreenWidth/2.0);
        make.centerY.mas_offset(kScreenHeight/2.0);
        make.size.mas_offset(CGSizeMake(200, 200));
    }];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targertSize = CGSizeMake(self.view.width * scale, self.view.height*scale);
    void(^completeBlock)(UIImage *) = ^(UIImage *image){
        if (image) {
            [GCDQueue executeInMainQueue:^{
                self.localImgV.image = image;
            }];
        }
    };
    //progressBlock 不执行，bug
    void(^progressBlock)(double ,NSError *,BOOL *,NSDictionary *) = ^(double progress,NSError *error,BOOL *stop,NSDictionary *info){
        //            NSLog(@"progress-----%f",progress);
    };
    [[ImageManager shareInstance] SynRequestImageWithAssert:self.localModel.phasset andTargetSize:targertSize andCompelete:completeBlock andRequestProgress:progressBlock];

}

-(void)singleTapClick:(UITapGestureRecognizer *)gestureRecognizer{
    CGFloat NavNeedOffset = _navISHidden ? 20 : -88;
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.navigationBar.y = NavNeedOffset;
    }];
    _navISHidden = !_navISHidden;
}


@end
