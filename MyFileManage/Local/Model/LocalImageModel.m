//
//  LocalImageModel.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "LocalImageModel.h"
#import "ImageManager.h"

@implementation LocalImageModel

-(instancetype)initWithCollection:(PHCollection *)collection{
    if (self = [super init]) {
        
        self.title = collection.localizedTitle;
        PHAssetCollection *assec = (PHAssetCollection *)collection;
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assec options:options];
        PHAsset *firstObj = result.firstObject;
        [[ImageManager shareInstance] SynRequestImageWithAssert:firstObj andtTargertSize:CGSizeMake(200, 200) andCompelete:^(UIImage *image) {
            self.image = image;
        }];
        self.count = result.count;
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    LocalImageModel *model =[[LocalImageModel alloc] init];
    model.image = self.image;
    model.title = self.title;
    model.count = self.count;
    return model;
}

@end
