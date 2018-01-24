//
//  localCell.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/23.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "LocalImageModel.h"

@interface localCell : UITableViewCell

@property(nonatomic,strong)UIImageView *firstImagV;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *count;
@property(nonatomic,strong)LocalImageModel *localImage;

@end
