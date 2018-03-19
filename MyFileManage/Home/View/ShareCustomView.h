//
//  ShareCustomView.h
//  MyFileManage
//
//  Created by Viterbi on 2018/3/19.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCustomView : UIActivity

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, strong) NSArray * shareContexts;
- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type  withShareContext:(NSArray *)shareContexts;

@end
