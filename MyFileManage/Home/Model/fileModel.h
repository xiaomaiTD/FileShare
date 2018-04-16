//
//  fileModel.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fileModel : NSObject<NSCopying>

-(instancetype)initWithFilePath:(NSString *)path;

@property(nonatomic,assign)BOOL isFolder; //是否为文件夹
@property(nonatomic,strong)NSString *name;//文件名.文件后缀
@property(nonatomic,strong)NSString *fileName; //文件名
@property(nonatomic,strong)NSString *fullPath;//文件全路径 绝对路径
@property(nonatomic,strong)NSString *realtivePath;//文件全路径 绝对路径
@property(nonatomic,strong)NSString *fileType;//文件类型。(png,txt,zip,avi etc..)
@property(nonatomic,assign)BOOL isSystemFolder;// 是否为系统文件夹，（下载，隐藏等
@property(nonatomic,assign)BOOL selected;//在首页是否被选择

@property(nonatomic,assign)BOOL isUserFull;//在其他路径是否可用

@property(nonatomic,assign,readonly)BOOL isVideo;//是否为视频资源
@property(nonatomic,assign,readonly)BOOL isPhoto;//是否为图片资源
@property(nonatomic,assign,readonly)BOOL isPdf;//是否为图片资源

@end
