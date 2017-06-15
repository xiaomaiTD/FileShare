//
//  ReadChapterModel.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/15.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ReadChapterModel.h"
#import <CoreText/CoreText.h>

@interface ReadChapterModel()


@property(nonatomic,assign)NSUInteger pageCount;

@property(nonatomic,strong)NSMutableArray *pageArray;

@end

@implementation ReadChapterModel

-(instancetype)init{


    if (self = [super init]) {
        
        _pageArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    
    return self;
    
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
    

 /// werwrwrwrwrwr
   // CGRectMakeWithDictionaryRepresentation(rwrewrwrwrwer, <#CGRect * _Nullable rect#>)
}

-(NSString *)stringOfPage:(NSUInteger)index{


    return [NSString stringWithFormat:@"%lu",(unsigned long)_pageArray.count];

}

@end
