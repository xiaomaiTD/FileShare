//
//  FolderFileManager.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fileModel.h"

@interface FolderFileManager : NSObject

+(instancetype)shareInstance;

-(NSString *)getDocumentPath;
-(NSString *)getCachePath;
-(NSString *)getBeHiddenFolderPath;
-(NSString *)getCycleFolderPath;
-(NSString *)getDownloadFolderPath;


/**
 判断路径是否存在

 @param path 路径
 @return YES／NO
 */
-(BOOL)judgePathIsExits:(NSString *)path;

/**
 获得上传文件路径

 @return 路径地址
 */
-(NSString *)getUploadPath;

/**
 删除文件以及文件夹

 @param path 文件路径
 */
-(void )deleteFileInPath:(NSString *)path;

/**
 删除指定文件下的内容，但不删除文件夹

 @param path 路径
 */
-(BOOL)deleteContentFileInDic:(NSString *)dir;

/**
 创建文件夹

 @param path 文件路径
 */
-(void )createDirWithPath:(NSString *)path;

/**
 创建文本

 @param path 文本路径
 */
-(void)createTextWithPath:(NSString *)path;
-(NSString *)createFileWithPath:(NSString *)path;

/**
 获得指定路径下的所有model

 @param dir 路径文件夹
 @return model array;
 */
-(NSArray *)getAllFileModelInDic:(NSString *)dir;

/**
 创建隐藏文件夹
 */
-(void)createIsBeHiddenFolder;

/**
 创建垃圾回收站
 */
-(void)createRecycleFolder;

/**
 创建系统文件夹,包括隐藏文件夹，垃圾回收站等.
 */
-(void)createSystemFolder;

/**
 将文件移动的垃圾回收站
 */
-(void)moveToRecyleFolderFromPath:(NSString *)resourcePath;


/**
 移动文件到哪里

 @param resource 从哪里
 @param destination 到哪里
 */
-(void)moveFileFromPath:(NSString *)resource toDestionPath:(NSString *)destination;
-(void)copyFileFromPath:(NSString *)resource toDestionPath:(NSString *)destination;


@end
