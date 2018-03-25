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
@property(nonatomic,strong)FMDatabaseQueue *dbQueue;

@property(nonatomic,strong)FMDatabase *historyDB;
@property(nonatomic,strong)FMDatabaseQueue *historyQueue;

@end

@implementation FMDBTool

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FMDBTool alloc] init];
        [tool createDataBase];
        [tool createHistoryDB];
    });
    return tool;
}


-(void)createHistoryDB{
    
    NSString *dataBasePath = [[[FolderFileManager shareInstance] getDocumentPath] stringByAppendingPathComponent:@"history.sqlite"];
    self.historyDB = [FMDatabase databaseWithPath:dataBasePath];
    self.historyQueue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataBasePath]) {
        return;
    }
    if ([self.historyDB open]) {
        NSString *collection = @"CREATE TABLE 'history' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'isFolder' integer default 0,'name' VARCHAR(255),'fileName' VARCHAR(255),'fullPath' VARCHAR(255),'fileType' VARCHAR(255),'isSystemFolder'  integer default 0,'realtivePath' VARCHAR(255)) ";
        [self.historyDB executeUpdate:collection];
        [self.historyDB close];
    }
}

-(BOOL)addHistoryModel:(fileModel *)model{
    
    NSString *addSql = @"insert into history(isFolder,name,fileName,fullPath,fileType,isSystemFolder,realtivePath)values(?,?,?,?,?,?,?)";
    if ([self.historyDB open]) {
        FMResultSet *res = [self.historyDB executeQuery:@"SELECT * FROM history where realtivePath = ?",model.realtivePath];
        if (res.next) {
            [self deleteHistoryModel:model];
        }
        [self.historyDB open];
        [self.historyDB executeUpdate:addSql,@(model.isFolder),model.name,model.fileName,model.fullPath,model.fileType,@(model.isSystemFolder),model.realtivePath];
        
        [self.historyDB close];

        return NO;
    }
    return NO;
}

-(BOOL)deleteHistoryModel:(fileModel *)model{
    if ([self.historyDB open]) {
        [self.historyDB executeUpdate:@"DELETE FROM history WHERE realtivePath = ?",model.realtivePath];
        [self.historyDB close];
        return YES;
    }
    return NO;
}

-(void)deleteAllHistoryModel:(void (^)(BOOL))complete{
    
    [self.historyQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            [db executeUpdate:@"DELETE FROM history"];
        }
        [db close];
    }];
}

-(void)selectedAllHistoryModel:(selectedComplete)complete{
    
    [self.historyQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
            FMResultSet *res = [db executeQuery:@"SELECT * FROM history"];
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
            [db close];
            if (complete) {
                complete(dataArray);
            }
        }
    }];
}

#pragma mark----创建收藏
-(void)createDataBase{
    
    NSString *dataBasePath = [[[FolderFileManager shareInstance] getDocumentPath] stringByAppendingPathComponent:@"collection.sqlite"];
    self.db = [FMDatabase databaseWithPath:dataBasePath];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
    
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

-(void)selectedCollectionModel:(selectedComplete)complete{
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
            FMResultSet *res = [db executeQuery:@"SELECT * FROM collection"];
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
            [db close];
            if (complete) {
                complete(dataArray);
            }
        }
    }];
    
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
