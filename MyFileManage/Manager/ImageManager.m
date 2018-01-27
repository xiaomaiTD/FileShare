//
//  PHImageManage.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "ImageManager.h"

static ImageManager *manager = nil;

@interface ImageManager()

@property(nonatomic,strong)PHCachingImageManager *cacheImageManager;
@property(nonatomic,strong)PHImageRequestOptions *options;

@end

@implementation ImageManager

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ImageManager alloc] init];
    });
    return manager;
    
}

-(instancetype)init{
    if (self = [super init]) {
        self.cacheImageManager = [[PHCachingImageManager alloc] init];
        self.options = [[PHImageRequestOptions alloc] init];
    }
    return self;
}

-(void)SynRequestImageWithAssert:(PHAsset *)asset andtTargertSize:(CGSize)tagertSize andCompelete:(ImageManagerBlock)block{

    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [self.options setSynchronous:YES];
    [self.cacheImageManager requestImageForAsset:asset targetSize:tagertSize contentMode:PHImageContentModeAspectFit options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        block(result);
    }];

}

-(void)SynRequestImageWithAssert:(PHAsset *)asset andTargetSize:(CGSize)targetSize andCompelete:(ImageManagerBlock)block andRequestProgress:(requestProgress)progressblock{
    
    self.options.progressHandler = [progressblock copy];
    [self.options setSynchronous:NO];
    [self.options setNetworkAccessAllowed:YES];
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [self.cacheImageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        block(result);
    }];

}

@end
