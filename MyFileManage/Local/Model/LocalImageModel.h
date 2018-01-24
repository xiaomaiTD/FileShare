//
//  LocalImageModel.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LocalImageModel : NSObject<NSCopying>

-(instancetype)initWithCollection:(PHAssetCollection *)collection;

/**
 相册的第一张图片
 */
@property(nonatomic,strong)UIImage *image;

/**
 相册的名字
 */
@property(nonatomic,copy)NSString *title;

/**
 相册的数量
 */
@property(nonatomic,assign)NSInteger count;

@property(nonatomic,strong)PHAssetCollection *collection;
@property(nonatomic,strong)PHFetchResult *result;


@end
