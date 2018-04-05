//
//  localImageAndVideoCell.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalImageAndVideoModel.h"

@interface localImageAndVideoCell : UICollectionViewCell

@property(nonatomic,strong)LocalImageAndVideoModel *model;

/**
photo 标识符
 */
@property(nonatomic,strong)NSString *localIdentifier;

@end
