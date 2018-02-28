//
//  receiveFileTableCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/28.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "receiveFileTableCell.h"

@implementation receiveFileTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
      self.fileNameLable = [[UILabel alloc] initWithFrame:CGRectZero];
      self.fileNameLable.text = @"test";
      self.fileNameLable.font = [UIFont systemFontOfSize:15];
      [self addSubview:self.fileNameLable];
      [self.fileNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self).mas_offset(15);
          make.left.equalTo(self).mas_offset(20);
          make.bottom.equalTo(self).mas_offset(-15);
          make.centerY.equalTo(self);
         // make.size.width.mas_equalTo(30);
      }];
      
      self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
      self.progressView.progress = 0.5;
      [self addSubview:self.progressView];
      [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.fileNameLable.mas_right).mas_equalTo(10);
          make.centerY.equalTo(self.mas_centerY);
          make.right.equalTo(self).mas_equalTo(-10);
      }];

      self.doneImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
      [self addSubview:self.doneImageV];
      self.doneImageV.hidden = YES;
      [self.doneImageV mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(-8);
          make.centerY.equalTo(self);
      }];
      
      UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectZero];
      bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
      [self addSubview:bottomLine];
      [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(0);
          make.right.mas_equalTo(0);
          make.bottom.mas_equalTo(0);
          make.size.height.mas_equalTo(1);
      }];
      
  }
  return self;
}

-(void)layoutSubviews{
    self.fileNameLable.layer.cornerRadius = 5;
    self.fileNameLable.layer.masksToBounds = YES;
}

@end
