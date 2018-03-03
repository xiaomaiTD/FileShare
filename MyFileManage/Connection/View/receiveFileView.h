//
//  receiveFileTableCell.h
//  MyFileManage
//
//  Created by Viterbi on 2018/2/28.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface receiveFileView : UIView

@property(nonatomic,strong)UILabel *fileNameLable;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)UIImageView *doneImageV;
@property(nonatomic,copy)NSString *fileName;

-(void)updateProgressViewWithValue:(CGFloat)value;

@end
