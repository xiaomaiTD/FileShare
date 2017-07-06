//
//  CATiledLayer.m
//  PDFDemo
//
//  Created by 掌上先机 on 2017/7/5.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFCATiledLayer.h"

@implementation PDFCATiledLayer


+ (CFTimeInterval)fadeDuration
{
    return 0.5;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.levelsOfDetail = 16;
        self.levelsOfDetailBias = 16 - 1;
        self.tileSize = CGSizeMake(4096, 4096);
        
      //  self.backgroundColor = [UIColor redColor].CGColor;
    }
    return self;
}

@end
