//
//  FolderFileManager.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FolderFileManager.h"
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
    if (self) {}
    return self;
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

-(void)deleteFileInPath:(NSString *)path{
    NSFileManager *manage = [NSFileManager defaultManager];
    [manage removeItemAtPath:path error:nil];
}

-(void)createTextWithPath:(NSString *)path{
    NSFileManager *manag = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![manag fileExistsAtPath:path isDirectory:&isDir]) {
        [manag createFileAtPath:path contents:nil attributes:nil];
    }else{
        NSString *filename = [[path lastPathComponent] stringByDeletingPathExtension];
        // 判断是不是存在 - 的后缀
        if ([filename containsString:@"-"]) {
            NSInteger fileCount = [[[filename componentsSeparatedByString:@"-"] lastObject] integerValue];
            NSRange range = [filename rangeOfString:@"-" options:NSBackwardsSearch];
            filename = [filename substringWithRange:NSMakeRange(0, range.location)];
            fileCount = fileCount + 1;
            filename = [filename stringByAppendingString:[NSString stringWithFormat:@"-%ld.%@",(long)fileCount,path.pathExtension]];
            NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
            [self createTextWithPath:newPath];
            
        }else{
            // 不存在的话直接往后面加 -1
            filename = [NSString stringWithFormat:@"%@.%@",[filename stringByAppendingString:@"-1"],[path pathExtension]];
            NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
            [self createTextWithPath:newPath];
        }
    }
}

-(void )createDirWithPath:(NSString *)path{
    NSFileManager *manage = [NSFileManager defaultManager];
    if (![manage fileExistsAtPath:path]) {
        [manage createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        // 存在的文件名
        NSString *filename = [path lastPathComponent];
        // 判断是不是存在 - 的后缀
        if ([filename containsString:@"-"]) {
            NSInteger fileCount = [[[filename componentsSeparatedByString:@"-"] lastObject] integerValue];
            NSRange range = [filename rangeOfString:@"-" options:NSBackwardsSearch];
            filename = [filename substringWithRange:NSMakeRange(0, range.location)];
            fileCount = fileCount + 1;
            filename = [filename stringByAppendingString:[NSString stringWithFormat:@"-%ld",(long)fileCount]];
            NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
            [self createDirWithPath:newPath];
            
        }else{
            // 不存在的话直接往后面加 -1
            filename = [filename stringByAppendingString:@"-1"];
            NSString *newPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
            [self createDirWithPath:newPath];
        }
    }
}
-(void)createIsBeHiddenFolder{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getBeHiddenFolderPath]]) {
         [self createDirWithPath:[self getBeHiddenFolderPath]];
    }
}

-(void)createRecycleFolder{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getCycleFolderPath]]) {
        [self createDirWithPath:[self getCycleFolderPath]];
    }
}

-(void)createSystemFolder{
    [self createRecycleFolder];
    [self createIsBeHiddenFolder];
}

-(void)moveToRecyleFolderFromPath:(NSString *)resourcePath{
    NSString *recyclePath = [self getCycleFolderPath];
    NSFileManager *manage = [NSFileManager defaultManager];
    if (![manage fileExistsAtPath:recyclePath]) {
        [self createDirWithPath:recyclePath];
    }
    NSError *error = nil;
    BOOL moveSuccess = [manage moveItemAtPath:resourcePath toPath:[recyclePath stringByAppendingPathComponent:[resourcePath lastPathComponent]] error:&error];
    NSLog(@"success------%d",moveSuccess);
    NSLog(@"error------%@",error);
}

-(NSArray *)getAllFileModelInDic:(NSString *)dir{
    
    NSArray *fileModelArray = [[[self getAllFilesName:dir] firstleap_filter:^BOOL(NSString *files) {
        return ![files isEqualToString:@".DS_Store"];
    }] firstleap_map:^fileModel *(NSString *files) {
        return [[fileModel alloc] initWithFilePath:[NSString stringWithFormat:@"%@/%@",dir,files]];
    }];
    return fileModelArray;
}
-(NSArray *)getAllFilesName:(NSString *)dir{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
    return files;
}


@end
