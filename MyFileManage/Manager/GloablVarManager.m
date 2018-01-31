//
//  GloablVarManager.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/31.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "GloablVarManager.h"

static GloablVarManager *manager = nil;

@implementation GloablVarManager

+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GloablVarManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.showFolderType = NO;
        self.showHiddenFolder = NO;
    }
    return self;
}

@end
