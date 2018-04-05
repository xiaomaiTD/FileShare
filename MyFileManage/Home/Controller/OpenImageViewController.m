//
//  openImageViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//
#import "OpenImageViewController.h"
#import "ImageManager.h"
#import "GCDQueue.h"
#import <ImageIO/ImageIO.h>
#import <iOSPhotoEditor/iOSPhotoEditor-Swift.h>
#import <SDWebImage/UIImage+GIF.h>
#import <PhotosUI/PhotosUI.h>


@interface OpenImageViewController ()<UIScrollViewDelegate,PhotoEditorDelegate>

@property(nonatomic,strong)UIScrollView *bgScrollView;
@property(nonatomic,strong)UIImageView *localImgV;
@property(nonatomic,strong)PHLivePhotoView *livePhotoView;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,assign)BOOL navISHidden;

@end

@implementation OpenImageViewController

-(void)loadView{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgScrollView.delegate = self;
    self.view = _bgScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navISHidden = YES;

    self.title = self.model.fileName;
    self.view.backgroundColor = [UIColor blackColor];
  
    UIButton * rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightItem;
    rightItem.frame = CGRectMake(0, 0, 40, 40);
    [rightItem setTitle:@"编辑" forState:UIControlStateNormal];
    [rightItem setTitle:@"发送" forState:UIControlStateSelected];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightItem setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [rightItem addTarget:self action:@selector(presentImageEdit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    if (self.localModel) {
        if (self.localModel.type == PHASSETTYPE_LivePhoto) {
            [self addLivePhotoView];
        }else{
            PHAssetResource *resource = [PHAssetResource assetResourcesForAsset:self.localModel.phasset].firstObject;
            BOOL isGif = [resource.originalFilename hasSuffix:@"GIF"];
            [self addStaticPhotoWithGif:isGif];
        }
    }else{
        if ([self.model.fileType.uppercaseString isEqualToString:@"GIF"]) {
            NSData *imageData = [NSData dataWithContentsOfFile:self.model.fullPath];
            UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
            self.localImgV = [[UIImageView alloc] initWithImage:image];
        }else{
            NSData *imageData = [NSData dataWithContentsOfFile:self.model.fullPath];
            UIImage *fileImage = [UIImage imageWithData:imageData];
            self.localImgV = [[UIImageView alloc] initWithImage:fileImage];
        }
        self.localImgV.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.localImgV];
        [self centerImageView];
    }
    
    [self addGest];
}

/**
 添加静态图片
 */
-(void)addStaticPhotoWithGif:(BOOL)gif{
    
    if (gif) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        [options setSynchronous:NO];
        [PHImageManager.defaultManager requestImageDataForAsset:self.localModel.phasset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            [GCDQueue executeInMainQueue:^{
                UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
                self.localImgV = [[UIImageView alloc] initWithImage:image];
                self.localImgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:self.localImgV];
                [self centerImageView];
            }];
        }];
        return;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targertSize = CGSizeMake(self.view.width * scale, self.view.height*scale);
    void(^completeBlock)(UIImage *) = ^(UIImage *image){
        if (image) {
            [GCDQueue executeInMainQueue:^{
                self.localImgV = [[UIImageView alloc] initWithImage:image];
                self.localImgV.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:self.localImgV];
                [self centerImageView];
            }];
        }
    };

    [[ImageManager shareInstance] SynRequestImageWithAssert:self.localModel.phasset andTargetSize:targertSize andCompelete:completeBlock andRequestProgress:nil];
}

/**
 添加livePhotoView
 */
-(void)addLivePhotoView{
    if (self.localModel.type != PHASSETTYPE_LivePhoto) {
        return;
    }
    self.livePhotoView = [[PHLivePhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.livePhotoView];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targertSize = CGSizeMake(self.view.width * scale, self.view.height*scale);
    void(^completeBlock)(PHLivePhoto *) = ^(PHLivePhoto *livephoto){
        if (livephoto) {
            [GCDQueue executeInMainQueue:^{
                self.livePhotoView.livePhoto = livephoto;
            }];
        }
    };
    //progressBlock 不执行，bug
    void(^progressBlock)(double ,NSError *,BOOL *,NSDictionary *) = ^(double progress,NSError *error,BOOL *stop,NSDictionary *info){
        
    };
    [[ImageManager shareInstance] SynRequestLivePhotoWithAssert:self.localModel.phasset andTargetSize:targertSize andCompelete:completeBlock andRequestProgress:progressBlock];
}

-(void)centerImageView{
    CGRect scrollViewFrame = self.view.bounds;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.localImgV.image.size.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.localImgV.image.size.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.bgScrollView.minimumZoomScale = minScale;
    self.bgScrollView.maximumZoomScale = MAX(minScale, self.bgScrollView.maximumZoomScale);
    self.bgScrollView.zoomScale = self.bgScrollView.minimumZoomScale;
    CGFloat horizontalInset = 0;
    CGFloat verticalInset = 0;
    
    if (self.bgScrollView.contentSize.width < CGRectGetWidth(self.bgScrollView.bounds)) {
        horizontalInset = (CGRectGetWidth(self.bgScrollView.bounds) - self.bgScrollView.contentSize.width) * 0.5;
    }
    if (self.bgScrollView.contentSize.height < CGRectGetHeight(self.bgScrollView.bounds)) {
        verticalInset = (CGRectGetHeight(self.bgScrollView.bounds) - self.bgScrollView.contentSize.height) * 0.5;
    }
    self.bgScrollView.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
}

-(void)addGest{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClick:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    if (self.localModel && self.localModel.type == PHASSETTYPE_LivePhoto) {
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(playLivePhot:)];
        longGes.minimumPressDuration = 1;
        [self.view addGestureRecognizer:longGes];
    }
}
/**
 播放livePhoto
 */
-(void)playLivePhot:(UIGestureRecognizer *)gest{
    if (gest.state == UIGestureRecognizerStateBegan) {
        [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    }
}

-(void)presentImageEdit{
    // gif图片不让编辑
    if ([self.model.fileType.uppercaseString isEqualToString:@"GIF"]) {
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

- (void)doubleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.localImgV];

    CGFloat newZoomScale = self.bgScrollView.maximumZoomScale;

    if (self.bgScrollView.zoomScale >= self.bgScrollView.maximumZoomScale
        || ABS(self.bgScrollView.zoomScale - self.bgScrollView.maximumZoomScale) <= 0.01) {
        newZoomScale = self.bgScrollView.minimumZoomScale;
    }

    CGSize scrollViewSize = self.bgScrollView.bounds.size;

    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat originX = pointInView.x - (width / 2.0);
    CGFloat originY = pointInView.y - (height / 2.0);
    CGRect rectToZoomTo = CGRectMake(originX, originY, width, height);

    [self.bgScrollView zoomToRect:rectToZoomTo animated:YES];
}

-(void)singleTapClick:(UITapGestureRecognizer *)gestureRecognizer{
    CGFloat NavNeedOffset = _navISHidden ? 20 : -88;
    [UIView animateWithDuration:0.25 animations:^{
        self.navigationController.navigationBar.y = NavNeedOffset;
    }];
    _navISHidden = !_navISHidden;
}

#pragma mark ----UIScrollviewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _localImgV;
}

#pragma mark ----photoEditorDelegate

-(void)canceledEditing{}
-(void)doneEditingWithImage:(UIImage *)image{
    _localImgV.image = image;
}

@end
