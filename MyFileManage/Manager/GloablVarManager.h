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

+(instancetype)shareManager;

@end
