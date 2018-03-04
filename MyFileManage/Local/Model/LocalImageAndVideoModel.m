//
//  LocalImageAndVideoModel.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "LocalImageAndVideoModel.h"
#import "ImageManager.h"

@implementation LocalImageAndVideoModel

-(instancetype)initWithAsset:(PHAsset *)asset{
    if (self = [super init]) {
        [[ImageManager shareInstance] SynRequestImageWithAssert:asset andtTargertSize:CGSizeMake(200, 200) andCompelete:^(UIImage *image) {
            self.PHImage = image;
        }];
        self.phasset = asset;
        self.selected = NO;

        if (self.phasset.mediaType == PHAssetMediaTypeVideo ) {
            self.type = PHASSETTYPE_Video;
            int mySeconds = (int)self.phasset.duration;
            int seconds = mySeconds % 60;
            int minutes = (mySeconds / 60) % 60;
            int hours = mySeconds / 3600;
            if (hours == 0) {
                self.videoLength = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
            }else{
                self.videoLength = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
            }
        }else {
            if (self.phasset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                self.type = PHASSETTYPE_LivePhoto;
            }else{
                self.type = PHASSETTYPE_Image;
            }
        }
    }
    return self;
}

@end
