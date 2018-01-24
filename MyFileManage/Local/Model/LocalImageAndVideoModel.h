//
//  LocalImageAndVideoModel.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    PHASSETTYPE_Video = 0,
    PHASSETTYPE_Image,
    PHASSETTYPE_LivePhoto,
} PHAssetType;

@interface LocalImageAndVideoModel : NSObject

@property(nonatomic,strong)PHAsset *phasset;
@property(nonatomic,strong)UIImage *PHImage;
@property(nonatomic,copy) NSString *videoLength;
@property(nonatomic,assign)PHAssetType type;

-(instancetype)initWithAsset:(PHAsset *)asset;


@end
