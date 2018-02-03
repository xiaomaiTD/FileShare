//
//  ResourceFileManager.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "ResourceFileManager.h"
#import "FolderFileManager.h"

static ResourceFileManager *manager = nil;

@implementation ResourceFileManager

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ResourceFileManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.musicEntities = [MusicEntity arrayOfEntitiesFromArray:[self getAllUploadMusicDic]].mutableCopy;
        //PDF data
        self.documentStore = [[PDFDocumentStore alloc] init];
    }
    return self;
}

/**
 构造 音乐列表字典
 
 @return array
 */
- (NSArray *) getAllUploadMusicDic
{
    NSArray *fileModelArray =  [[[[self getAllFilesName] firstleap_filter:^BOOL(NSString *obj) {
        return [obj hasSuffix:@"mp3"];
    }] firstleap_map:^NSDictionary * ( NSString *fileString) {
        
        NSString *fileName = [fileString stringByDeletingPathExtension];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@",FileUploadSavePath,fileString];
        NSDictionary *musicDic = @{@"name":fileName,
                                   @"fileName":fileName,
                                   @"fullPath":fullPath
                                   };
        return musicDic;
    }] copy];
    
    return fileModelArray;
}

/**
 获取所有file model
 
 @return array
 */
- (NSArray *) getAllUploadAllFileModels
{
    NSArray *fileModelArray = [[[self getAllFilesName] firstleap_filter:^BOOL(NSString *files) {
        return ![files isEqualToString:@".DS_Store"] && ![files isEqualToString:RecycleFolderName];
    }] firstleap_map:^fileModel *(NSString *files) {
        return [[fileModel alloc] initWithFilePath:[NSString stringWithFormat:@"%@/%@",FileUploadSavePath,files]];
    }];
    return fileModelArray;
}

- (NSArray *)getAllBeHiddenFolderFileModels{
    NSString *hiddenPath = [[FolderFileManager shareInstance] getBeHiddenFolderPath];
    return [[FolderFileManager shareInstance] getAllFileModelInDic:hiddenPath];
}

-(NSArray *) getAllRecycelFolderFileModels{
    NSString *recyclePath = [[FolderFileManager shareInstance] getCycleFolderPath];
    return [[FolderFileManager shareInstance] getAllFileModelInDic:recyclePath];
}

/**
 获取 MyFileManageUpload 文件夹下的所有文件名字
 
 @return 文件数组
 */
-(NSArray *)getAllFilesName{
    
    NSString *uploadDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    uploadDirPath = [NSString stringWithFormat:@"%@/MyFileManageUpload",uploadDirPath];
    NSMutableArray *files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:uploadDirPath error:nil] mutableCopy];
    if (![[DataBaseTool shareInstance] getShowHiddenFolderHidden]) {
        if ([files containsObject:HiddenFolderName]) {
            [files removeObject:HiddenFolderName];
        }
    }
    return [files copy];
}

@end
