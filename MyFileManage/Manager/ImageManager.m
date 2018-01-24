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
    }
    return self;
}

-(void)SynRequestImageWithAssert:(PHAsset *)asset andtTargertSize:(CGSize)tagertSize andCompelete:(ImageManagerBlock)block{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [options setSynchronous:YES];
    [self.cacheImageManager requestImageForAsset:asset targetSize:tagertSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        block(result);
    }];

}

@end
