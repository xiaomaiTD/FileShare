//
//  fileModel.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "fileModel.h"
#import "DataBaseTool.h"

@implementation fileModel

-(instancetype)initWithFilePath:(NSString *)path{

    if (self = [super init]) {
        self.fileName = [[path lastPathComponent] stringByDeletingPathExtension];
        
        self.isSystemFolder = NO;
        NSArray *systemArray = @[DownloadFolderName,HiddenFolderName];
        if ([systemArray containsObject:self.fileName]) {
            self.isSystemFolder = YES;
        }
        // 根据全局变量 是否要显示文件后缀名
        self.fileName = [[DataBaseTool shareInstance] getShowFileTypeHidden] ? [path lastPathComponent] :self.fileName;
        self.fileType = [path pathExtension];
        self.fullPath = path;
        BOOL folder = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&folder];
        self.isFolder = folder;
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
