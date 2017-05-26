//
//  ZoomImageView.h
//  WXWeibo
//


#import <UIKit/UIKit.h>

@class ZoomImageView;
@protocol ZoomImageViewDelegate <NSObject>

@optional
//1.图片将要放大
- (void)imageWillZoomIn:(ZoomImageView *)imageView;
//2.图片已经放大
- (void)imageDidZoomIn:(ZoomImageView *)imageView;

//3.图片将要缩小
- (void)imageWillZoomOut:(ZoomImageView *)imageView;
//4.图片已经缩小
- (void)imageDidZoomOut:(ZoomImageView *)imageView;
@end


//@class DDProgressView;
@interface ZoomImageView : UIImageView{
    
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;

}

//大图的url链接
@property(nonatomic,copy)NSString *urlstring;
//@property(nonatomic,assign)BOOL isGIF;

//代理对象
@property(nonatomic,assign)id<ZoomImageViewDelegate> delegate;

@end
