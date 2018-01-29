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
@property(nonatomic,strong)PHLivePhotoRequestOptions *LiveOptions;
@property(nonatomic,strong)PHVideoRequestOptions *VideoOptions;

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
        self.LiveOptions = [[PHLivePhotoRequestOptions alloc] init];
        self.VideoOptions = [[PHVideoRequestOptions alloc] init];
    }
    return self;
}

/**
 获取缩略图的方法

 @param asset 资源
 @param tagertSize 目标大小
 @param block 完成block
 */
-(void)SynRequestImageWithAssert:(PHAsset *)asset andtTargertSize:(CGSize)tagertSize andCompelete:(ImageManagerBlock)block{

    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    [self.options setSynchronous:YES];
    [self.cacheImageManager requestImageForAsset:asset targetSize:tagertSize contentMode:PHImageContentModeAspectFit options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        block(result);
    }];

}

/**
 获取大图

 @param asset 以上
 @param targetSize 以上
 @param block 以上
 @param progressblock 以上
 */
-(void)SynRequestImageWithAssert:(PHAsset *)asset andTargetSize:(CGSize)targetSize andCompelete:(ImageManagerBlock)block andRequestProgress:(requestProgress)progressblock{
    
    self.options.progressHandler = [progressblock copy];
    [self.options setSynchronous:NO];
    [self.options setNetworkAccessAllowed:YES];
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [self.cacheImageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        block(result);
    }];
}


/**
 获取livePhoto

 @param asset 以上
 @param targetSize 以上
 @param block 以上
 @param progressblock 以上
 */
-(void)SynRequestLivePhotoWithAssert:(PHAsset *)asset andTargetSize:(CGSize)targetSize andCompelete:(LiveImageManagerBlock)block andRequestProgress:(requestProgress)progressblock{
    
    self.LiveOptions.progressHandler = [progressblock copy];
    [self.LiveOptions setNetworkAccessAllowed:YES];
    self.LiveOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [self.cacheImageManager requestLivePhotoForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:self.LiveOptions resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        block(livePhoto);
    }];
}

/**
 请求video

 @param asset 以上
 @param block 返回回调
 */
-(void)SyncRequestVideoWithAssert:(PHAsset *)asset andCompelte:(VideoImageManagerBlock)block andRequestProgress:(requestProgress)progressblock{
    self.VideoOptions.progressHandler = progressblock;
    [self.VideoOptions setNetworkAccessAllowed:YES];
    self.VideoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [self.cacheImageManager requestPlayerItemForVideo:asset options:self.VideoOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        block(playerItem);
    }];
    
}

@end
