//
//  DataBaseTool.h
//  POSystem
//
//  Created by 掌上先机 on 17/2/15.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseTool : NSObject

+(instancetype)shareInstance;


/**
 存取ip地址

 @param ip ip字符串
 */
-(void)setIPAddree:(NSString *)ip;
-(NSString *)getIpAddress;


/**
 是否隐藏文件后缀名

 @param hidden 是否隐藏
 */
-(void)setShowFileTypeHidden:(BOOL)hidden;
-(BOOL)getShowFileTypeHidden;


/**
 是否显示隐藏文件夹

 @param hidden 是否隐藏
 */
-(void)setShowHiddenFolderHidden:(BOOL)hidden;
-(BOOL)getShowHiddenFolderHidden;

@end
