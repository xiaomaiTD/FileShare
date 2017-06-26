//
//  TXTReaderParse.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/15.
//  Copyright © 2017年 wangchao. All rights reserved.
//
#import "TXTReaderConfigue.h"
#import "TXTReaderParse.h"

@implementation TXTReaderParse

+(NSDictionary *)parserAttribute:(TXTReaderConfigue *)config
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = config.fontColor;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:config.fontSize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = config.lineSpace;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    return [dict copy];
}


+(CTFrameRef)parserContent:(NSString *)content  andBouds:(CGRect)bounds
{
    
    
    
    return [self parserContent:content config:[TXTReaderConfigue shareInstance] bouds:bounds];
    
}

//
+(CTFrameRef)parserContent:(NSString *)content config:(TXTReaderConfigue *)parser bouds:(CGRect)bounds
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSDictionary *attribute = [self parserAttribute:parser];
    [attributedString setAttributes:attribute range:NSMakeRange(0, content.length)];
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFRelease(setterRef);
    CFRelease(pathRef);
    return frameRef;
    
}
//获取默认选中区域

+(CGRect)parserRectWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef{

    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    CGRect rect = CGRectZero;
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return rect;
    }
    NSInteger lineCount = [lines count];
    //  CGPoint origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    
    CGPoint origins[lineCount];
    
    if (lineCount) {
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
            if (CGRectContainsPoint(lineFrame,point)){
                CFRange stringRange = CTLineGetStringRange(line);
                index = CTLineGetStringIndexForPosition(line, point);
                CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL);
                CGFloat xEnd;
                //默认选中两个单位
                if (index > stringRange.location+stringRange.length-2) {
                    xEnd = xStart;
                    xStart = CTLineGetOffsetForStringIndex(line,index-2,NULL);
                    (*selectRange).location = index-2;
                }
                else{
                    xEnd = CTLineGetOffsetForStringIndex(line,index+2,NULL);
                    (*selectRange).location = index;
                }
                
                (*selectRange).length = 2;
                rect = CGRectMake(origins[i].x+xStart,baselineOrigin.y-descent,fabs(xStart-xEnd), ascent+descent);
                
                break;
            }
        }
    }
    // free(origins);
    return rect;

}

+(NSArray *)parserRectsWithPoint:(CGPoint)point range:(NSRange *)selectRange frameRef:(CTFrameRef)frameRef paths:(NSArray *)paths direction:(BOOL)direction{

    CFIndex index = -1;
    NSArray *lines = (__bridge NSArray*)CTFrameGetLines(frameRef);
    
    NSMutableArray *pathArray = [[NSMutableArray alloc] initWithCapacity:0];


    NSInteger lineCount = [lines count];
    CGPoint origins[lineCount];
    
    index = [self parserIndexWithPoint:point frameRef:frameRef];
    
    if (index == -1) {
        
        return paths;
    }
    
    //x从右侧滑动
    if (direction) //从右侧滑动
    {
        if (!(index>(*selectRange).location)) {
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
        else{
            (*selectRange).length = index-(*selectRange).location;
        }
    }
    else    //从左侧滑动
    {
        if (!(index>(*selectRange).location+(*selectRange).length)) {
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
    }
    if (lineCount) {
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++){
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CFRange stringRange = CTLineGetStringRange(line);
            CGFloat xStart;
            CGFloat xEnd;
            NSRange drawRange = [self selectRange:NSMakeRange((*selectRange).location, (*selectRange).length) lineRange:NSMakeRange(stringRange.location, stringRange.length)];
            
            if (drawRange.length) {
                xStart = CTLineGetOffsetForStringIndex(line, drawRange.location, NULL);
                xEnd = CTLineGetOffsetForStringIndex(line, drawRange.location+drawRange.length, NULL);
                CGRect rect = CGRectMake(xStart, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
                if (rect.size.width ==0 || rect.size.height == 0) {
                    continue;
                }
                [pathArray addObject:NSStringFromCGRect(rect)];
            }
            
        }
        
    }



    return pathArray;
}
#pragma mark ------不是太懂

+(NSRange)selectRange:(NSRange)selectRange lineRange:(NSRange)lineRange
{
    NSRange range = NSMakeRange(NSNotFound, 0);
    if (lineRange.location>selectRange.location) {
        NSRange tmp = lineRange;
        lineRange = selectRange;
        selectRange = tmp;
    }
    if (selectRange.location<lineRange.location+lineRange.length) {
        range.location = selectRange.location;
        NSUInteger end = MIN(selectRange.location+selectRange.length, lineRange.location+lineRange.length);
        range.length = end-range.location;
    }
    return range;
}

+(CFIndex)parserIndexWithPoint:(CGPoint)point frameRef:(CTFrameRef)frameRef
{
    CFIndex index = -1;
    CGPathRef pathRef = CTFrameGetPath(frameRef);
    CGRect bounds = CGPathGetBoundingBox(pathRef);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frameRef);
    if (!lines) {
        return index;
    }
    NSInteger lineCount = [lines count];
    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    if (lineCount) {
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins);
        for (int i = 0; i<lineCount; i++) {
            CGPoint baselineOrigin = origins[i];
            CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
            CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
            CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
            CGRect lineFrame = CGRectMake(baselineOrigin.x, CGRectGetHeight(bounds)-baselineOrigin.y-ascent, lineWidth, ascent+descent+linegap);    //没有转换坐标系左下角为坐标原点 字体高度为上行高度加下行高度
            if (CGRectContainsPoint(lineFrame,point)){
                index = CTLineGetStringIndexForPosition(line, point);
                break;
            }
        }
    }
    free(origins);
    return index;
    
}



@end
