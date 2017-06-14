//
//  readTXTModel.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/14.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ReadTXTModel.h"

@implementation ReadTXTModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.content forKey:@"content"];
   
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
       
    }
    return self;
}
-(instancetype)initWithContentString:(NSString *)content{


    if (self = [super init]) {
        
        
        _content = content;
    }
    
    return self;


}

+(void)updateLocalModel:(ReadTXTModel *)readModel url:(NSURL *)url
{
    
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    
}


+(instancetype)getLocalModelWithUrl:(NSURL *)url{


    NSString *key = [url.path lastPathComponent];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    if (data == nil) {
        
        NSString *content;
        
        if (!url) {
            content = @"";
        }
        content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if (!content) {
            content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
        }
        if (!content) {
            content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
        }
        if (!content) {
            content = @"";
        }
        
        ReadTXTModel *mode = [[ReadTXTModel alloc] initWithContentString:content];
        
        [ReadTXTModel updateLocalModel:mode url:url];
        
        return mode;
        
        
    }
    //解码
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //主线程操作
    ReadTXTModel *model = [unarchive decodeObjectForKey:key];
    
    return model;




}

@end
