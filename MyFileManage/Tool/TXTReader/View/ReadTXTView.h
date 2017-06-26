//
//  ReadTXTView.h
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/14.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadTXTView : UIView

@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSString *content;

-(void)cancelSelected;

@end
