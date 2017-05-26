//
//  fileModel.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "fileModel.h"

@implementation fileModel

-(instancetype)initWithFileString:(NSString *)fileString{

    if (self = [super init]) {
        
        
        
        NSString *temp = nil;
        
        
        for(int i = 0; i <= (int)(fileString.length - 1); i++)
        {
            temp = [fileString substringWithRange:NSMakeRange( fileString.length - 1 - i, 1)];
            
            if ([temp isEqualToString:@"."]) {
                
                temp = [fileString substringWithRange:NSMakeRange(fileString.length -  i, i)];
                
                _fileType = temp;
                
                _fileName = [fileString substringWithRange:NSMakeRange(0, fileString.length -i - 1)];
                
                NSString *path = FileUploadSavePath;
                
                _fullPath = [NSString stringWithFormat:@"%@/%@.%@",path,_fileName,_fileType];
                
                break;
            }
            
        }
        
        
        
    }

    return self;


}

@end
