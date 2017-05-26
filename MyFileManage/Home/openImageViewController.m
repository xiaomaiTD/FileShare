//
//  openImageViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "openImageViewController.h"
#import "ZoomImageView.h"

#import <ImageIO/ImageIO.h>



@interface openImageViewController ()<UIScrollViewDelegate>


@property(nonatomic,strong)UIScrollView *bgScrollView;

@property(nonatomic,strong)ZoomImageView *localImgV;

@property(nonatomic)BOOL zoomOut_In;

@end

@implementation openImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _model.fileName;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_bgScrollView];
    
   

    NSData *imageData = [NSData dataWithContentsOfFile:_model.fullPath];
    
    
    UIImage *fileImage = [UIImage imageWithData:imageData scale:2];
    
    if (iPhone67sp) {
        
        fileImage = [UIImage imageWithData:imageData scale:3];
    }
    
    
     ZoomImageView *imgV = [[ZoomImageView alloc] initWithImage:fileImage];
    
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    
    _localImgV = imgV;
    
    
    if (fileImage) {
        
        _bgScrollView.delegate = self;
    }
    
    
    [_bgScrollView addSubview:imgV];
    
    _bgScrollView.contentSize = CGSizeMake(imgV.width, imgV.height);
    
    
}


-(void)dealloc{

    NSLog(@"dealloc");
}


@end
