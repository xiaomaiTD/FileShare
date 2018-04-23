//
//  SMBFolderCell.h
//  MyFileManage
//
//  Created by Viterbi on 2018/4/21.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMBClient/SMBClient.h>

@protocol SMBFolderCellDelegate<NSObject>
-(void)watchVideoCallback:(SMBFile *)smfile;
-(void)downloadFileCallback:(SMBFile *)smfile;
@end

@interface SMBFolderCell : UITableViewCell

@property(nonatomic,strong)UIImageView *icomImagV;
@property(nonatomic,strong)UIButton *downLoadBtn;
@property(nonatomic,strong)UIButton *watchBtn;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)SMBShare *share;
@property(nonatomic,strong)SMBFile *file;
@property(nonatomic,assign)id<SMBFolderCellDelegate>delegate;

@end
