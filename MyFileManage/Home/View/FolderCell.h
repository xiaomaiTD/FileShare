//
//  FolderCell.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileModel.h"

@interface FolderCell : UICollectionViewCell

@property(nonatomic,strong)fileModel *model;
@property(nonatomic,strong)UITextView *textView;
@end
