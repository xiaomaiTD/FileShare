//
//  OpenImagesPageViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/3.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import <iOSPhotoEditor/iOSPhotoEditor-Swift.h>
#import "OpenImagesPageViewController.h"
#import "UIViewController+Extension.h"
#import "OpenImageViewController.h"
#import "FolderFileManager.h"
#import "fileModel.h"

@interface OpenImagesPageViewController ()
<UIPageViewControllerDelegate,UIPageViewControllerDataSource,PhotoEditorDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) fileModel *currentModel;//当前的model;
@property (nonatomic, strong) LocalImageAndVideoModel *currentLocalModel;//当前的model;
@property(nonatomic,strong)OpenImageViewController *currentImagVC;
@end

@implementation OpenImagesPageViewController

-(NSArray *)picModelArray{
    if (!_picModelArray) {
        NSString *path = [self.model.fullPath stringByDeletingLastPathComponent];
        _picModelArray = [[FolderFileManager shareInstance] getAllPicModelInDic:path];
    }
    return _picModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton * rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = rightItem;
    rightItem.frame = CGRectMake(0, 0, 40, 40);
    [rightItem setTitle:@"编辑" forState:UIControlStateNormal];
    [rightItem setTitle:@"发送" forState:UIControlStateSelected];
    rightItem.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    @weakify(self);
    [self.rightBtn addTargetWithBlock:^(UIButton *sender) {
        @strongify(self);
        [self presentImageEdit];
    }];
    [self addRigthItemWithCustomView:rightItem];
    
    self.navigationController.navigationBar.y = -self.navigationController.navigationBar.height;
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(0)};

    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
   __block NSInteger index = 0;
    if (self.photoModelArray.count > 0) {
        index = [self.photoModelArray indexOfObject:self.localModel];
    }else{
        [self.picModelArray enumerateObjectsUsingBlock:^(fileModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.fullPath isEqualToString:self.model.fullPath]) {
                index = idx;
            }
        }];
    }

    NSArray *viewControllers = [NSArray arrayWithObject:[self viewControllerAtIndex:index]];
    
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    _pageViewController.view.frame = self.view.bounds;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}
-(void)presentImageEdit{
    // gif图片不让编辑
    if ([self.currentModel.fileType.uppercaseString isEqualToString:@"GIF"]) {
        return;
    }
    if (_currentImagVC.isGif) {
        return;
    }
    if (_currentImagVC.currentLocalImage == nil) {
        return;
    }
    PhotoEditorViewController *photoEdit = [[PhotoEditorViewController alloc] initWithNibName:@"PhotoEditorViewController" bundle:[NSBundle bundleForClass:[PhotoEditorViewController class]]];
    photoEdit.image = _currentImagVC.currentLocalImage;
    photoEdit.photoEditorDelegate = self;
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<=10; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [imageArray addObject:img];
    }
    photoEdit.stickers = [imageArray copy];
    [self presentViewController:photoEdit animated:YES completion:nil];
}

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(OpenImageViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(OpenImageViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.picModelArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(OpenImageViewController *)viewControllerAtIndex:(NSInteger )index{
    if (self.localModel) {
        if (self.photoModelArray.count == 0 || self.photoModelArray.count <= index){
            return nil;
        }
        LocalImageAndVideoModel *model = [self.photoModelArray objectAtIndex:index];
        OpenImageViewController *vc = [[OpenImageViewController alloc] init];
        _currentImagVC = vc;
        vc.localModel = model;
        return vc;
    }else{
        if (self.picModelArray.count == 0 || self.picModelArray.count <= index) {
            return nil;
        }
        fileModel *model = [self.picModelArray objectAtIndex:index];
        OpenImageViewController *vc = [[OpenImageViewController alloc] init];
        _currentImagVC = vc;
        vc.model = model;
        return vc;
    }
}
- (NSUInteger)indexOfViewController:(OpenImageViewController *)viewController {
    if (self.localModel) {
        return [self.photoModelArray indexOfObject:viewController.localModel];
    }
    return [self.picModelArray indexOfObject:viewController.model];
}
#pragma mark ----photoEditorDelegate

-(void)canceledEditing{}
-(void)doneEditingWithImage:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


@end
