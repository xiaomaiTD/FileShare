//
//  ReadTXTPageViewController.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/14.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadTXTView.h"


@interface ReadTXTPageViewController : UIViewController

@property(nonatomic,strong)ReadTXTView *textView;

//电子书 所以字符串
@property(nonatomic,copy)NSString *content;


@end
