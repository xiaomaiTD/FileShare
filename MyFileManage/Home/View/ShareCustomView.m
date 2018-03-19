//
//  ShareCustomView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/19.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "ShareCustomView.h"

@implementation ShareCustomView

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type withShareContext:(NSArray *)shareContexts{
    
    if(self == [super init]){
        _title = title;
        _image = image;
        _url = url;
        _type = type;
        _shareContexts = shareContexts;
    }
    return self;
    
}

+ (UIActivityCategory)activityCategory{
    return UIActivityCategoryAction;
}

- (NSString *)activityType{
    return _type;
}

- (NSString *)activityTitle {
    return _title;
}

- (UIImage *)_activityImage {
    return _image;
}

- (NSURL *)activityUrl{
    return _url;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if (activityItems.count > 0) {
        return YES;
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    //准备分享所进行的方法，通常在这个方法里面，把item中的东西保存下来,items就是要传输的数据
}

- (void)performActivity {
    //用safari打开网址
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ViterbiDevelopment"]];
    [self activityDidFinish:YES];
    
}

@end
