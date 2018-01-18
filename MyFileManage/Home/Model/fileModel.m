//
//  fileModel.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "fileModel.h"

@implementation fileModel

-(instancetype)initWithFilePath:(NSString *)path{

    if (self = [super init]) {
        
        self.fileName = [[path lastPathComponent] stringByDeletingPathExtension];
        self.fileType = [path pathExtension];
        self.fullPath = path;
        self.isFolder = self.fileType.length == 0 ? YES:NO;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{

    fileModel *model = [[fileModel alloc] init];
    model.fileName = self.fileName;
    model.fileType = self.fileType;
    model.fullPath = self.fullPath;
    model.isFolder = self.isFolder;
    return model;
}


@end
