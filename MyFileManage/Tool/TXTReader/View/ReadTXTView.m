//
//  ReadTXTView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/14.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ReadTXTView.h"
#import "TXTReaderParse.h"
#import "ReadTXTMagnifierView.h"


@interface ReadTXTView()
{

    NSRange _selectRange;
    NSArray *_pathArray;


}

@property(nonatomic,strong)ReadTXTMagnifierView *magnifierView;

@end

@implementation ReadTXTView



-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self addGestureRecognizer:({
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            
            longPress;
        
        })];
        

        
        
        
    }

    return self;

}

-(void)longPress:(UILongPressGestureRecognizer *)gester{


    [self hideenMagnifierView];
    
    CGPoint point = [gester locationInView:self];
    
    if (gester.state  == UIGestureRecognizerStateBegan || gester.state == UIGestureRecognizerStateChanged) {
        
        [self showMagnifierView];
        
        _magnifierView.touchPoint = point;
        

        CGRect rect = [TXTReaderParse parserRectWithPoint:point range:&_selectRange frameRef:_frameRef];
        
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            
            _pathArray = @[NSStringFromCGRect(rect)];
            [self setNeedsDisplay];

        }
        
        
    }
    if (gester.state == UIGestureRecognizerStateEnded) {
        
        [self hideenMagnifierView];
    }
    

    

}

-(void)drawRect:(CGRect)rect{


    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    [self drawSelectedPath:_pathArray];
    
    
    
    CTFrameDraw(_frameRef, ctx);
   // CFRelease(_frameRef);
    
    
}

#pragma mark  Draw Selected Path
-(void)drawSelectedPath:(NSArray *)array{
    if (!array.count) {
        
        return;
    }
    
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor redColor]setFill];
    for (int i = 0; i < [array count]; i++) {
        CGRect rect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(_path, NULL, rect);
        
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
    
}



-(void)showMagnifierView{
    
    
    if (!_magnifierView) {
        
        _magnifierView = [[ReadTXTMagnifierView alloc] init];
        
        _magnifierView.readView = self;
        
        [self addSubview:_magnifierView];
        
    }
    
}
-(void)hideenMagnifierView{
    
    if (_magnifierView) {
        
        [_magnifierView removeFromSuperview];
        
        _magnifierView = nil;
    }
    
    
}


@end
