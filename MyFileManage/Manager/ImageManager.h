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

@interface ImageManager : NSObject

+(instancetype)shareInstance;

-(void)SynRequestImageWithAssert:(PHAsset *)asset andtTargertSize:(CGSize )tagertSize andCompelete:(ImageManagerBlock)block;

@end
