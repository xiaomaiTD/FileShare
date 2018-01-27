//
//  PHImageManage.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^ImageManagerBlock)(UIImage *image);
typedef void(^LiveImageManagerBlock)(PHLivePhoto *livePhoto);
typedef void(^requestProgress)(double progress,NSError *errir,BOOL *stop,NSDictionary *info);

@interface ImageManager : NSObject

+(instancetype)shareInstance;

-(void)SynRequestImageWithAssert:(PHAsset *)asset andtTargertSize:(CGSize )tagertSize andCompelete:(ImageManagerBlock)block;

-(void)SynRequestImageWithAssert:(PHAsset *)asset andTargetSize:(CGSize)targetSize andCompelete:(ImageManagerBlock)block andRequestProgress:(requestProgress)progressblock;

-(void)SynRequestLivePhotoWithAssert:(PHAsset *)asset andTargetSize:(CGSize)targetSize andCompelete:(LiveImageManagerBlock)block andRequestProgress:(requestProgress)progressblock;

@end
