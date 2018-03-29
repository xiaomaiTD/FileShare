
#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property(nonatomic,assign)CGFloat maxX;
@property(nonatomic,assign)CGFloat maxY;

@property(nonatomic,assign)CGFloat Defont;

-(void)setTitle:(NSString *)title;
-(void)setTitleColor:(UIColor *)color;

- (CGSize)getSizeWithText:(NSString *)text width:(CGFloat)width;

- (CGSize)getSizeWithText:(NSString *)text font:(CGFloat)font width:(CGFloat)width;

-(CGSize)getWidthWithText:(NSString *)text height:(CGFloat)height;

-(CGSize)getWidthWithText:(NSString *)text font:(CGFloat)font height:(CGFloat)height;

-(CGSize)getSizeWithText:(NSString *)text font:(CGFloat)font width:(CGFloat)width isBold:(BOOL)bold;

-(BOOL)valiMobile:(NSString *)mobile;



@end
