//
//  FolderFileManager.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import "DataBaseTool.h"
#import "FolderFileManager.h"
#import "ResourceFileManager.h"
#import "GloablVarManager.h"
#import "NSFileManager+GreatReaderAdditions.h"

static FolderFileManager *manage = nil;

@implementation FolderFileManager

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[FolderFileManager alloc] init];
    });
    return manage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadFolderPath = [[DataBaseTool shareInstance] getDownloadPath].length == 0 ? [[self getUploadPath] stringByAppendingPathComponent:DownloadFolderName] : [[DataBaseTool shareInstance] getDownloadPath];
    }
    return self;
}

-(void)setDownloadFolderPath:(NSString *)downloadFolderPath{
    if (![downloadFolderPath isEqualToString:_downloadFolderPath]) {
        _downloadFolderPath = downloadFolderPath;
        [[DataBaseTool shareInstance] setDownloadPath:_downloadFolderPath];
    }
}

-(NSString *)getCachePath{
    return [NSFileManager grt_cachePath];
}

-(NSString *)getDocumentPath{
    return [NSFileManager grt_documentsPath];
}

-(NSString *)getUploadPath{
    return [NSFileManager grt_cacheUploadPath];
}

-(NSString *)getBeHiddenFolderPath{
    return [[self getUploadPath] stringByAppendingPathComponent:HiddenFolderName];
}

-(NSString *)getCycleFolderPath{
    return [[self getUploadPath] stringByAppendingPathComponent:RecycleFolderName];
}

-(NSString *)getDownloadFolderPath{
    return self.downloadFolderPath;
}

-(BOOL)judgePathIsExits:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(void)deleteFileInPath:(NSString *)path{
    NSFileManager *manage = [NSFileManager defaultManager];
    [manage removeItemAtPath:path error:nil];
}
-(BOOL)deleteContentFileInDic:(NSString *)dir{
    
    NSFileManager *manage = [NSFileManager defaultManager];
    BOOL isDir = NO;
    NSError *error = nil;
    if ([manage fileExistsAtPath:dir isDirectory:&isDir]) {
        if (!isDir) {
            return NO;
        }
        NSArray *filesArray = [manage contentsOfDirectoryAtPath:dir error:nil];
        NSEnumerator *e = [filesArray objectEnumerator];
        NSString *fileName;
        while (fileName = [e nextObject]) {
            [manage removeItemAtPath:[dir stringByAppendingPathComponent:fileName] error:&error];
        }
    }
    if (error) {
        return NO;
    }else{
        return YES;
    }
}

-(void)createTextWithPath:(NSString *)path{
    NSFileManager *manag = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![manag fileExistsAtPath:path isDirectory:&isDir]) {
        [manag createFileAtPath:path contents:nil attributes:nil];
    }else{
        NSString *filename = [[path lastPathComponent] stringByDeletingPathExtension];
        filename = [NSString stringWithFormat:@"%@.%@",[self replaceLineWithFileName:filename],path.pathExtension];

        NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
        [self createTextWithPath:newPath];
    }
}

-(NSString *)createFileWithPath:(NSString *)path{
    
    NSFileManager *manag = [NSFileManager defaultManager];
    BOOL isDir = NO;
    
    if (![manag fileExistsAtPath:path isDirectory:&isDir]) {
        [manag createFileAtPath:path contents:nil attributes:nil];
        return path;
    }else{
        NSString *filename = [[path lastPathComponent] stringByDeletingPathExtension];
        filename = [NSString stringWithFormat:@"%@.%@",[self replaceLineWithFileName:filename],path.pathExtension];
        NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
        return [self createFileWithPath:newPath];
    }
}

-(void )createDirWithPath:(NSString *)path{
    NSFileManager *manage = [NSFileManager defaultManager];
    if (![manage fileExistsAtPath:path]) {
        [manage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        // 存在的文件名
        NSString *filename = [path lastPathComponent];
        //替换 - 。如果没有-1，如果有就 -%d
        filename = [self replaceLineWithFileName:filename];
        NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
        [self createDirWithPath:newPath];
    }
}

/**
 创建下载文件夹
 */
-(void)createDownloadFolder{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getDownloadFolderPath]]) {
        if (![GloablVarManager shareManager].isHaveDownloadFolder) {
            [self createDirWithPath:[self getDownloadFolderPath]];
            [GloablVarManager shareManager].isHaveDownloadFolder = YES;
        }
    }
}

-(void)createIsBeHiddenFolder{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getBeHiddenFolderPath]]) {
        if (![GloablVarManager shareManager].isHaveHiddenFolder) {
            [self createDirWithPath:[self getBeHiddenFolderPath]];
            [GloablVarManager shareManager].isHaveHiddenFolder = YES;
        }
    }
}

-(void)createRecycleFolder{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getCycleFolderPath]]) {
        if (![GloablVarManager shareManager].isHaveRecyleFolder) {
            [self createDirWithPath:[self getCycleFolderPath]];
            [GloablVarManager shareManager].isHaveRecyleFolder = YES;
        }
    }
}

-(void)createSystemFolder{
    [self createRecycleFolder];
    [self createIsBeHiddenFolder];
    [self createDownloadFolder];
}

-(void)moveToRecyleFolderFromPath:(NSString *)resourcePath{
    // 移动到隐藏文件夹的时候防止没有创建成功
    NSString *recyclePath = [self getCycleFolderPath];
    NSFileManager *manage = [NSFileManager defaultManager];
    if (![manage fileExistsAtPath:recyclePath]) {
        [self createDirWithPath:recyclePath];
    }
    // 获取hidden目录下的所有文件
    NSArray *hiddenDirArray = [[ResourceFileManager shareInstance] getAllRecycelFolderFileModels];
    
    [self realMoveToRecyleFolderWithHiddenArray:hiddenDirArray andResourcePath:resourcePath andRecyleName:[[resourcePath lastPathComponent] stringByDeletingPathExtension]];
}

-(void)realMoveToRecyleFolderWithHiddenArray:(NSArray *)hiddenDirArray andResourcePath:(NSString *)resourcePath andRecyleName:(NSString *)recycleName{

    // 判读是不是文件夹
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:resourcePath isDirectory:&isDir];
    
    //  目标 回收站路径
    NSString *recyclePath = nil;
    if (isDir) {
        recyclePath = [[self getCycleFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",recycleName]];
    }else{
        recyclePath = [[self getCycleFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",recycleName,[resourcePath pathExtension]]];
    }
    BOOL haveRepeatFile = [[NSFileManager defaultManager] fileExistsAtPath:recyclePath];
    // 如果和回收站有相同的文件或者文件夹
    if (haveRepeatFile) {
        NSString *filename = [self replaceLineWithFileName:recycleName];
        // 循环调用判断是否有相同文件或者文件夹
        [self realMoveToRecyleFolderWithHiddenArray:hiddenDirArray andResourcePath:resourcePath andRecyleName:filename];
    }else{
        NSError *error = nil;
        BOOL moveSuccess = [[NSFileManager defaultManager] moveItemAtPath:resourcePath toPath:recyclePath error:&error];
        NSLog(@"success------%d",moveSuccess);
        NSLog(@"error------%@",error);
    }
}

-(void)moveFileFromPath:(NSString *)resource toDestionPath:(NSString *)destination{
    // 判读是不是文件夹
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:resource isDirectory:&isDir];
    //stringByDeletingPathExtension
    NSString *destionationFileName = [[resource lastPathComponent] stringByDeletingPathExtension];
    NSLog(@"destionationFileName------%@",destionationFileName);
    NSString *destinationPath = nil;
    if (isDir) {
        destinationPath = [destination stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",destionationFileName]];
    }else{
        destinationPath = [destination stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",destionationFileName,resource.pathExtension]];
    }
    [self moveFileFromPath:resource toDestionPath:destinationPath andDestionName:destionationFileName];
}

-(void)moveFileFromPath:(NSString *)resource toDestionPath:(NSString *)destination andDestionName:(NSString *)destionName{
    
    BOOL haveRepeatFile = [[NSFileManager defaultManager] fileExistsAtPath:destination];
    if (haveRepeatFile) {
        NSString *fileName = [self replaceLineWithFileName:destionName];
        destination = [[[destination stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,resource.pathExtension]] copy];
        [self moveFileFromPath:resource toDestionPath:destination andDestionName:fileName];
    }else{
        NSError *error = nil;
        BOOL moveSuccess = [[NSFileManager defaultManager] moveItemAtPath:resource toPath:destination error:&error];
        NSLog(@"success------%d",moveSuccess);
        NSLog(@"error------%@",error);
    }
}


- (void)copyFileFromPath:(NSString *)resource toDestionPath:(NSString *)destination{
    // 判读是不是文件夹
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:resource isDirectory:&isDir];
    //stringByDeletingPathExtension
    NSString *destionationFileName = [[resource lastPathComponent] stringByDeletingPathExtension];
    NSLog(@"destionationFileName------%@",destionationFileName);
    NSString *destinationPath = nil;
    if (isDir) {
        destinationPath = [destination stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",destionationFileName]];
    }else{
        destinationPath = [destination stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",destionationFileName,resource.pathExtension]];
    }
    [self copyFileFromPath:resource toDestionPath:destinationPath andDestionName:destionationFileName];
    
}

-(void)copyFileFromPath:(NSString *)resource toDestionPath:(NSString *)destination andDestionName:(NSString *)destionName{
    
    BOOL haveRepeatFile = [[NSFileManager defaultManager] fileExistsAtPath:destination];
    if (haveRepeatFile) {
        NSString *fileName = [self replaceLineWithFileName:destionName];
        destination = [[[destination stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,resource.pathExtension]] copy];
        [self copyFileFromPath:resource toDestionPath:destination andDestionName:fileName];
    }else{
        NSError *error = nil;
        BOOL copySuccess = [[NSFileManager defaultManager] copyItemAtPath:resource toPath:destination error:&error];
        NSLog(@"success------%d",copySuccess);
        NSLog(@"error------%@",error);
    }
}

-(NSString *)replaceLineWithFileName:(NSString *)fileName{
    if ([fileName containsString:@"-"]) {
        NSInteger fileCount = [[[fileName componentsSeparatedByString:@"-"] lastObject] integerValue];
        NSRange range = [fileName rangeOfString:@"-" options:NSBackwardsSearch];
        fileName = [fileName substringWithRange:NSMakeRange(0, range.location)];
        fileCount = fileCount + 1;
        fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)fileCount]];
    }else{
        fileName = [fileName stringByAppendingString:@"-1"];
    }
    return [fileName copy];
}

-(NSArray *)getAllFileModelInDic:(NSString *)dir{
    
    NSArray *fileModelArray = [[[self getAllFilesName:dir] firstleap_filter:^BOOL(NSString *files) {
        return ![files isEqualToString:@".DS_Store"];
    }] firstleap_map:^fileModel *(NSString *files) {
        return [[fileModel alloc] initWithFilePath:[NSString stringWithFormat:@"%@/%@",dir,files]];
    }];
    return fileModelArray;
}


-(NSArray *)getAllPicModelInDic:(NSString *)dir{
    
    NSArray *filePath = [[[self getAllFilesName:dir] firstleap_filter:^BOOL(NSString *files) {
        return [SupportPictureArray containsObject:files.pathExtension.uppercaseString];
    }] firstleap_map:^fileModel *(NSString *files) {
        return [[fileModel alloc] initWithFilePath:[NSString stringWithFormat:@"%@/%@",dir,files]];
    }];
    
    return filePath;
}


-(NSArray *)getAllFilesName:(NSString *)dir{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
    return files;
}


@end
