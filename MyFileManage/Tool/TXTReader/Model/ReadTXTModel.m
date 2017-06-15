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
    [aCoder encodeObject:self.pageArray forKey:@"pageArray"];
   
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        
        self.pageArray = [aDecoder decodeObjectForKey:@"pageArray"];
    }
    return self;
}
-(instancetype)initWithContentString:(NSString *)content{


    if (self = [super init]) {
        
        
        _content = content;
        
        _pageArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self dividePageWithBounds:CGRectMake(0, 0, kScreenWidth - 32, kScreenHeight - 32)];
        
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


-(void)dividePageWithBounds:(CGRect)bounds{
    
    [_pageArray removeAllObjects];
    NSAttributedString *attrString;
    CTFramesetterRef frameSetter;
    CGPathRef path;
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString  alloc] initWithString:self.content];
    
    attrString = [attrStr copy];
    frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        } else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageArray.count == 0) {
                [_pageArray addObject:@(currentOffset)];
            }
            else {
                
                NSUInteger lastOffset = [[_pageArray lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    [_pageArray addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [_pageArray addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    _pageCount = _pageArray.count;
    
    
    
}

-(NSString *)stringOfPage:(NSUInteger)index{
    
    _currentPage = index;
    
    NSUInteger local = [_pageArray[index] integerValue];
    NSUInteger length;
    if (index<self.pageCount-1) {
        length=  [_pageArray[index+1] integerValue] - [_pageArray[index] integerValue];
    }
    else{
        length = _content.length - [_pageArray[index] integerValue];
    }
    
    return [_content substringWithRange:NSMakeRange(local, length)];
}


@end
