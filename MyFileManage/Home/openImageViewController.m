//
//  openImageViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "openImageViewController.h"

@interface openImageViewController ()


@property(nonatomic,strong)UIScrollView *bgScrollView;

@end

@implementation openImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _model.fileName;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_bgScrollView];
    
    

    UIImage *fileImage = [UIImage imageWithContentsOfFile:_model.fullPath];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:fileImage];
    
    
    [_bgScrollView addSubview:imgV];
    
    _bgScrollView.contentSize = CGSizeMake(imgV.width, imgV.height);
    
    


}


@end
