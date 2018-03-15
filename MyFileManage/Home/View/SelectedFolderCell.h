//
//  SelectedFolderCell.h
//  MyFileManage
//
//  Created by Viterbi on 2018/3/15.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileModel.h"

@interface SelectedFolderCell : UICollectionViewCell

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)fileModel *model;

@end
