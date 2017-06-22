//
//  ReadTXTView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/14.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ReadTXTView.h"
#import "ReadTXTMagnifierView.h"


@interface ReadTXTView()


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
        
        
    }
    
//    NSLog(@"point---------%@",NSStringFromCGPoint(point));
    
    

}

-(void)drawRect:(CGRect)rect{


    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CTFrameDraw(_frameRef, ctx);
    
    CFRelease(_frameRef);
    
    
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
