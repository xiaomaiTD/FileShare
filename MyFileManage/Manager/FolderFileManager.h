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
 创建文件夹

 @param path 文件路径
 */
-(void )createDirWithPath:(NSString *)path;

/**
 创建文本

 @param path 文本路径
 */
-(void)createTextWithPath:(NSString *)path;

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

@end
