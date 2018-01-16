//
//  NSObject+firstLeap.h
//  firstleapKit
//
//  Created by Viterbi on 2017/10/13.
//  Copyright © 2017年 firstLeap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

/***************************对象方法****************************************/

/**
 NSDiction || NSArray 转换为 json字符串
 @return NSString 字符串
 */
-(NSString *)valueToJson;


/**
 map函数

 @param block 传入条件block
 @return NSArray
 */
- (NSArray *)firstleap_map:(id (^)(id))block;


/**
 filter函数

 @param block 传入条件filter函数
 @return NSArray
 */
- (NSArray *)firstleap_filter:(BOOL (^)(id))block;


/**
 判断是否为 nil @"" @"  " @"\n"

 @return bool
 */
-(BOOL)isNotBlank;


/**
 描述一个字符串是否包含另一个字符串

 @param string 被包含的字符串
 */
- (BOOL)containsString:(NSString *)string;

/**
 register KVO

 @param keyPath keyPath
 @param block block 回调通知
 */
- (void)addObserverBlockForKeyPath:(NSString*)keyPath
                             block:(void (^)(id obj, id  oldVal, id  newVal))block;


/**
 和 addObserverBlockForKeyPath 一块使用

 @param keyPath keyPath
 */
- (void)removeObserverBlocksForKeyPath:(NSString*)keyPath;


/**
 移除所有注册的keypath
 */
- (void)removeObserverBlocks;

/***************************类方法****************************************/

+ (NSString *)stringWithUUID;





@end
