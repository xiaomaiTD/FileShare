//
//  GloablVarManager.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/31.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GloablVarManager : NSObject

/**
 是否显示隐藏文件夹
 */
@property(nonatomic,assign)BOOL showHiddenFolder;

/**
 是否隐藏文件扩展名
 */
@property(nonatomic,assign)BOOL showFolderType;

//已经含有系统隐藏文件夹
@property(nonatomic,assign)BOOL isHaveHiddenFolder;

@property(nonatomic,assign)BOOL isHaveRecyleFolder;

@property(nonatomic,assign)BOOL isHaveDownloadFolder;


/**
 SMB协议主机域名
 */
@property(nonatomic,strong)NSString *SMBHost;


/**
 SMB协议主机域名和第一个share的全路径
 */
@property(nonatomic,strong)NSString *SMBAndFirstSharePath;


/**
 SMB
 */
@property(nonatomic,strong)NSString *SMBFirstShareName;

@property(nonatomic,strong)NSString *SMBUserName;
@property(nonatomic,strong)NSString *SMBUserPassword;


/**
 SMB全域名
 */
@property(nonatomic,strong)NSString *SMBFullPath;
@property(nonatomic,strong)NSString *SMBFilePath;

+(instancetype)shareManager;

@end
