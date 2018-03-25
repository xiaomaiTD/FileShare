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
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataBasePath]) {
        return;
    }
    if ([self.db open]) {
        NSString *collection = @"CREATE TABLE 'collection' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'isFolder' integer default 0,'name' VARCHAR(255),'fileName' VARCHAR(255),'fullPath' VARCHAR(255),'fileType' VARCHAR(255),'isSystemFolder'  integer default 0,'realtivePath' VARCHAR(255)) ";
        [_db executeUpdate:collection];
        [_db close];
    }
}

-(BOOL)addCollectionModel:(fileModel *)model{
    
    NSString *addSql = @"insert into collection(isFolder,name,fileName,fullPath,fileType,isSystemFolder,realtivePath)values(?,?,?,?,?,?,?)";
    if ([_db open]) {
        FMResultSet *res = [_db executeQuery:@"SELECT * FROM collection where realtivePath = ?",model.realtivePath];
        
        if (!res.next) {
            [_db executeUpdate:addSql,@(model.isFolder),model.name,model.fileName,model.fullPath,model.fileType,@(model.isSystemFolder),model.realtivePath];
            
            [_db close];
            return YES;
        }
        return NO;
    }
    return NO;
}

-(NSArray *)selectedCollectionModel{
    
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM collection"];
    while ([res next]) {
        fileModel *file = [[fileModel alloc] init];
        file.isFolder = [[res stringForColumn:@"isFolder"] boolValue];
        file.name = [res stringForColumn:@"name"];
        file.fileName = [res stringForColumn:@"fileName"];
        file.fullPath = [[[FolderFileManager shareInstance] getUploadPath] stringByAppendingPathComponent:[res stringForColumn:@"realtivePath"]];
        file.fileType = [res stringForColumn:@"fileType"];
        file.isSystemFolder = [res stringForColumn:@"isSystemFolder"];
        file.realtivePath = [res stringForColumn:@"realtivePath"];
        [dataArray addObject:file];
    }
    [_db close];
    return dataArray.copy;
}

-(BOOL)deleteCollectionModel:(fileModel *)model{
    
    if ([_db open]) {
        [_db executeUpdate:@"DELETE FROM collection WHERE realtivePath = ?",model.realtivePath];
        [_db close];
        return YES;
    }
    return NO;
}

@end
