//
//  GloablVarManager.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/31.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GloablVarManager : NSObject

@property(nonatomic,assign)BOOL showHiddenFolder;
@property(nonatomic,assign)BOOL showFolderType;

+(instancetype)shareManager;

@end
