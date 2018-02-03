//
//  ResourceFileManager.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFDocumentStore.h"
#import "MusicEntity.h"
#import "MusicViewController.h"
#import "fileModel.h"

@interface ResourceFileManager : NSObject


/**
 音乐数组
 */
@property(nonatomic,strong)NSMutableArray *musicEntities;

/**
 PDF 管理器
 */
@property(nonatomic,strong)PDFDocumentStore *documentStore;


+(instancetype)shareInstance;
/**
 构造 音乐列表字典
 
 @return array
 */
- (NSArray *) getAllUploadMusicDic;

/**
 获取所有file model
 
 @return array
 */
- (NSArray *) getAllUploadAllFileModels;


/**
 获取隐藏文件夹下的所有model

 @return array
 */
- (NSArray *) getAllBeHiddenFolderFileModels;


/**
 获得回收站里面的所有model

 @return array
 */
- (NSArray *) getAllRecycelFolderFileModels;

/**
 获取 MyFileManageUpload 文件夹下的所有文件名字
 
 @return 文件数组
 */
-(NSArray *)getAllFilesName;

@end
