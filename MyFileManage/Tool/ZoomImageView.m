//
//  ZoomImageView.m
//  WXWeibo
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"


@implementation ZoomImageView {
    
    double _length;
    NSMutableData *_data;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initTap];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self _initTap];
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    
    self = [super initWithImage:image];
    
    if (self) {
        
        [self _initTap];
        
    }
    return self;
    
}


- (void)_initTap {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    
    //开启触摸事件
    self.userInteractionEnabled = YES;
    
    //设置内容的模式：
    // UIViewContentModeScaleAspectFit 等比例放大
    self.contentMode = UIViewContentModeScaleAspectFit;
    
}

//创建放大之后，显示的子视图
- (void)_createView {
    
    if (_scrollView == nil) {
        //1.创建滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor=[UIColor blackColor];
        
        [self.window addSubview:_scrollView];
        
        //2.创建大图图片视图
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
   
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto:)];
       // 设置长按的时间
        longPress.minimumPressDuration = 2;
        [_scrollView addGestureRecognizer:longPress];
    }
}

//1、放大图片
- (void)zoomIn {
    
//#warning 将要放大
    //调用代理对象将要放大的协议方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    
    //隐藏缩略图
    self.hidden = YES;
    
    //1.创建放大的子视图
    [self _createView];
    
    //2.放大图片
    //坐标转换：当前视图的坐标 ----> 在window上显示的坐标
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _fullImageView.frame = _scrollView.bounds;
        
    } completion:^(BOOL finished) {
//#warning 判断URL，显示进度条
        if (self.urlstring.length > 0) {
//            _progressView.hidden = NO;
        }
        _scrollView.backgroundColor = [UIColor blackColor];
        
//#warning 将要放大
        //调用代理对象将要放大的协议方法
        if ([self.delegate respondsToSelector:@selector(imageDidZoomIn:)]) {
            [self.delegate imageDidZoomIn:self];
        }
        
    }];
    

    
}

//2.缩小图片
- (void)zoomOut {
    
//#warning 将要缩小
    //调用代理对象将要放大的协议方法
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    
    //取消网络请求
//    [_connection cancel];
    
    
    //1.缩小的动画效果
//    _progressView.hidden = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        
//#warning 将要缩小
        //调用代理对象将要放大的协议方法
        if ([self.delegate respondsToSelector:@selector(imageDidZoomOut:)]) {
            [self.delegate imageDidZoomOut:self];
        }
        
        
    } completion:^(BOOL finished) {
        
        //2.缩小之后，显示缩略图
        self.hidden = NO;
        
        //3.移除_scrollView
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
//        _progressView = nil;
        
    }];
    
}


//保存图片到相册
- (void)savePhoto:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIImage *img=_fullImageView.image;
        //UIImage *img = [UIImage imageWithData:_data];
        if (img != nil) {
            
            //1.提示保存
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            hud.labelText = @"正在保存";
            hud.dimBackground = YES;
            
            //2.将大图图片保存到相册
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)(hud));
            
        }
    }
    
}

//保存图片到相册成功之后调用的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    //提示保存成功
    MBProgressHUD *hud = (__bridge MBProgressHUD *)(contextInfo);
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
}


@end
