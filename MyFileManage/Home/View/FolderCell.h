//
//  FolderCell.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "fileModel.h"


@protocol FolderCellDelegate<NSObject>

-(void)folderCellLongPressWithModel:(fileModel *)model;
@end

@interface FolderCell : UICollectionViewCell

@property(nonatomic,assign)id<FolderCellDelegate>delegate;
@property(nonatomic,strong)fileModel *model;
@property(nonatomic,strong)UILabel *textView;
@property(nonatomic,strong)UIImageView *folderImage;

@end
