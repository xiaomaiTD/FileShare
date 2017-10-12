//
//  PDFContentView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/6.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "PDFContentView.h"
#import "PDFLoopView.h"


@interface PDFContentView()


@property(nonatomic,strong)PDFPage *page;

@property (nonatomic, strong)PDFLoopView *loopeView;



@end

@implementation PDFContentView

-(instancetype)initWithPage:(PDFPage *)page{


    if (self = [super init]) {
        _loopeView = [[PDFLoopView alloc] init];
        _page = page;
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
        [self addGestureRecognizer:tap];
    }
    return self;


}


-(void)longPressGes:(UITapGestureRecognizer *)recognizer{

    CGPoint point = [recognizer locationInView:self];

    if (recognizer.state != UIGestureRecognizerStateEnded) {
        [self showLoopeAtPoint:point andInView:[self superview]];
    }else{
    
        [self hideLoopView];
    }
}

-(void)hideLoopView{
    [self.loopeView removeFromSuperview];
}

-(void)showLoopeAtPoint:(CGPoint)point andInView:(UIView *)containerView{

    if (!self.loopeView.superview) {
        [containerView addSubview:self.loopeView];
    }
    point = [self convertPoint:point toView:containerView];
    self.loopeView.center = CGPointMake(roundf(point.x), roundf(point.y));
    UIGraphicsBeginImageContextWithOptions(self.loopeView.frame.size, NO, 4.0);  {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPoint p = [self convertPoint:self.loopeView.frame.origin
                              fromView:containerView];
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformConcat(transform, self.transform);
        transform = CGAffineTransformTranslate(transform, -p.x, -p.y);
        CGContextConcatCTM(context, transform);
        [self.layer renderInContext:context];
        self.loopeView.image = UIGraphicsGetImageFromCurrentImageContext();
    } UIGraphicsEndImageContext();
    
    self.loopeView.center =
    CGPointMake(self.loopeView.center.x,
                self.loopeView.center.y - self.loopeView.frame.size.height / 2.0 - 20);

    
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{

    [_page drawInRect:self.bounds inContext:ctx cropping:NO];
    
}

+(Class)layerClass
{
    return [PDFCATiledLayer class];

}



@end
