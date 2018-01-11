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
@property(nonatomic,assign)BOOL zoomOut_In;

@end

@implementation openImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _model.fileName;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_bgScrollView];
    
    if ([_model.fileType.uppercaseString isEqualToString:@"GIF"]) {
        NSData *imageData = [NSData dataWithContentsOfFile:_model.fullPath];
        UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
        self.localImgV = [[UIImageView alloc] initWithImage:image];
        
    }else{
        NSData *imageData = [NSData dataWithContentsOfFile:_model.fullPath];
        UIImage *fileImage = [UIImage imageWithData:imageData scale:2];
        if (iPhone67sp) {
            fileImage = [UIImage imageWithData:imageData scale:3];
        }
        self.localImgV = [[UIImageView alloc] initWithImage:fileImage];
    }
    
    self.localImgV.center = self.bgScrollView.center;
    [_bgScrollView addSubview:_localImgV];
    
    UITapGestureRecognizer* DoubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTapClick:)];//给imageview添加tap手势
    DoubleTap.numberOfTapsRequired = 2;//双击图片执行tapGesAction
    _localImgV.userInteractionEnabled=YES;
    [_localImgV addGestureRecognizer:DoubleTap];
    _zoomOut_In = YES;//控制点击图片放大或缩小
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick:)];
    singleTap.numberOfTapsRequired = 1;
    [_localImgV addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:DoubleTap];
    
    _bgScrollView.maximumZoomScale=2.0;//最大倍率（默认倍率）
    _bgScrollView.minimumZoomScale=0.1;//最小倍率（默认倍率）
    _bgScrollView.decelerationRate=1.0;//减速倍率（默认倍率）
    [_bgScrollView addSubview:_localImgV];
    _bgScrollView.contentSize = CGSizeMake(_localImgV.width, _localImgV.height);
}

#pragma mark ---- 弹出编辑视图，待开发
-(void)singleTapClick:(UITapGestureRecognizer *)gestureRecognizer{

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
#pragma mark ----photoEditorDelegate

-(void)canceledEditing{
    
}
-(void)doneEditingWithImage:(UIImage *)image{
    
    _localImgV.image = image;
}

-(void)DoubleTapClick:(UIGestureRecognizer*)gestureRecognizer//手势执行事件
{
    float newscale=0.0;
    if (_zoomOut_In) {
        newscale = 2*1.5;
        _zoomOut_In = NO;
    }else
    {
        newscale = 1.0;
        _zoomOut_In = YES;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
    [_bgScrollView zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
    
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    zoomRect.size.height = [_bgScrollView frame].size.height / scale;
    zoomRect.size.width  = [_bgScrollView frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _localImgV;
}

@end
