//
//  PDFLoopView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/16.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFLoopView.h"

@implementation PDFLoopView

- (instancetype)init
{
    self = [super initWithFrame:[[self class] frame]];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (CGRect)frame
{
    return CGRectMake(0, 0, 200, 98);
}

+ (CGFloat)cornerRadius
{
    return IsPhone() ? 10.0 : 14.0;
}

+ (CGRect)arrowRect
{
    return IsPhone() ? CGRectMake(40, 60, 20, 10)
    : CGRectMake(80, 74, 40, 14);
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat right = CGRectGetWidth(self.frame);
    CGRect arrowRect = [[self class] arrowRect];
    CGFloat bottom = CGRectGetHeight(self.frame) - CGRectGetHeight(arrowRect);
    CGFloat radius = [[self class] cornerRadius];
    [bezierPath moveToPoint:CGPointMake(right / 2.0, 0)];
    [bezierPath addArcWithCenter:CGPointMake(right - radius, radius)
                          radius:radius
                      startAngle:-M_PI / 2.0
                        endAngle:0
                       clockwise:YES];
    [bezierPath addArcWithCenter:CGPointMake(right - radius, bottom - radius)
                          radius:radius
                      startAngle:0
                        endAngle:M_PI / 2.0
                       clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(right / 2.0 + CGRectGetWidth(arrowRect) / 2.0, bottom)];
    [bezierPath addLineToPoint:CGPointMake(right / 2.0, bottom + CGRectGetHeight(arrowRect))];
    [bezierPath addLineToPoint:CGPointMake(right / 2.0 - CGRectGetWidth(arrowRect) / 2.0, bottom)];
    [bezierPath addArcWithCenter:CGPointMake(radius, bottom - radius)
                          radius:radius
                      startAngle:M_PI / 2.0
                        endAngle:M_PI
                       clockwise:YES];
    [bezierPath addArcWithCenter:CGPointMake(radius, radius)
                          radius:radius
                      startAngle:M_PI
                        endAngle:M_PI * 3.0 / 2.0
                       clockwise:YES];
    [bezierPath closePath];
    [bezierPath addClip];
    
    [[UIColor clearColor] set];
    
    //[[UIColor colorWithWhite:128/255.0 alpha:1.0] set];
    UIRectFill(rect);
    [self.image drawInRect:CGRectMake(-CGRectGetWidth(rect) / 2.0,
                                      -CGRectGetHeight(rect) / 2.0 - CGRectGetHeight([[self class] arrowRect]) / 2.0,
                                      CGRectGetWidth(rect) * 2.0,
                                      CGRectGetHeight(rect) * 2.0)];
    
    [UIColor.blackColor set];
    [bezierPath stroke];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

@end
