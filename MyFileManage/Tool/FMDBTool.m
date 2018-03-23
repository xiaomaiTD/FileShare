//
//  FMDBTool.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/23.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import "FolderFileManager.h"
#import "FMDBTool.h"

#import <FMDB/FMDB.h>

static FMDBTool *tool = nil;

@interface FMDBTool()

@property(nonatomic,strong)FMDatabase *db;

@end

@implementation FMDBTool

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FMDBTool alloc] init];
        [tool createDataBase];
    });
    return tool;
}

-(void)createDataBase{
    
    NSString *dataBasePath = [[[FolderFileManager shareInstance] getDocumentPath] stringByAppendingPathComponent:@"collection.sqlite"];
    self.db = [FMDatabase databaseWithPath:dataBasePath];
    
    if ([self.db open]) {
        NSLog(@"创建成功");
    }

}

@end
