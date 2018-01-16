//
//  openImageViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "openImageViewController.h"
#import <ImageIO/ImageIO.h>
#import <iOSPhotoEditor/iOSPhotoEditor-Swift.h>
#import <SDWebImage/UIImage+GIF.h>

@interface openImageViewController ()<UIScrollViewDelegate,PhotoEditorDelegate>

@property(nonatomic,strong)UIScrollView *bgScrollView;
@property(nonatomic,strong)UIImageView *localImgV;
@property(nonatomic,assign)BOOL navISHidden;

@end

@implementation openImageViewController


-(void)loadView{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    self.view = _bgScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.y = -88;
    _navISHidden = YES;
    self.title = _model.fileName;
    self.view.backgroundColor = [UIColor blackColor];
  
    UIButton * rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 0, 40, 40);
    [rightItem setTitle:@"编辑" forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightItem setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(presentImageEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    
    if ([_model.fileType.uppercaseString isEqualToString:@"GIF"]) {
        
        NSData *imageData = [NSData dataWithContentsOfFile:_model.fullPath];
        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        self.localImgV = [[UIImageView alloc] initWithImage:image];
        
    }else{
        NSData *imageData = [NSData dataWithContentsOfFile:_model.fullPath];
        UIImage *fileImage = [UIImage imageWithData:imageData scale:2];
        if (isPhonePlus()) {
            fileImage = [UIImage imageWithData:imageData scale:3];
        }
        self.localImgV = [[UIImageView alloc] initWithImage:fileImage];
    }
    
    self.localImgV.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    [self.view addSubview:_localImgV];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
   
    
}

-(void)presentImageEdit{
    // gif图片不让编辑
    if ([_model.fileType.uppercaseString isEqualToString:@"GIF"]) {
        return;
    }
    
    PhotoEditorViewController *photoEdit = [[PhotoEditorViewController alloc] initWithNibName:@"PhotoEditorViewController" bundle:[NSBundle bundleForClass:[PhotoEditorViewController class]]];
    photoEdit.image = _localImgV.image;
    photoEdit.photoEditorDelegate = self;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<=10; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [imageArray addObject:img];
    }
    photoEdit.stickers = [imageArray copy];
    
    [self presentViewController:photoEdit animated:YES completion:nil];
}

#pragma mark ---- 弹出编辑视图，待开发
-(void)singleTapClick:(UITapGestureRecognizer *)gestureRecognizer{

    
    CGFloat NavNeedOffset = _navISHidden ? 20 : -88;
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.navigationBar.y = NavNeedOffset;
    }];
    _navISHidden = !_navISHidden;
    
   

}
#pragma mark ----photoEditorDelegate

-(void)canceledEditing{
    
}
-(void)doneEditingWithImage:(UIImage *)image{
    
    _localImgV.image = image;
}



@end
