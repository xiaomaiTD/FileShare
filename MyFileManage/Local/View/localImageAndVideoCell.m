//
//  localImageAndVideoCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "localImageAndVideoCell.h"

@interface localImageAndVideoCell()

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIImageView *videoImagV;
@property(nonatomic,strong)UILabel *videoLength;
@property(nonatomic,strong)UIImageView *livePhotoImagV;

@end

@implementation localImageAndVideoCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc] init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(0);
            make.right.mas_offset(0);
            make.bottom.mas_offset(0);
        }];
    }
    self.livePhotoImagV = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.livePhotoImagV.backgroundColor = [UIColor redColor];
    [self addSubview:self.livePhotoImagV];
    [self.livePhotoImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.top.mas_offset(5);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    self.videoImagV = [[UIImageView alloc] init];
    self.videoImagV.image = [UIImage imageNamed:@"video"];
    [self addSubview:self.videoImagV];
    
    self.videoLength = [[UILabel alloc] initWithFrame:CGRectZero];
    self.videoLength.backgroundColor = [UIColor clearColor];
    self.videoLength.textColor = [UIColor whiteColor];
    self.videoLength.font = [UIFont systemFontOfSize:10];
    self.videoLength.text = @"text";
    [self addSubview:self.videoLength];
    
    [self.videoImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.left.mas_offset(0);
        make.right.equalTo(self.videoLength.mas_left).mas_offset(0);
        make.size.height.mas_equalTo(10);
        make.size.width.equalTo(self.videoLength.mas_width);
    }];
    [self.videoLength mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.right.mas_offset(0);
        make.left.equalTo(self.videoImagV.mas_right).mas_offset(0);
        make.size.height.mas_equalTo(10);
        make.size.width.equalTo(self.videoImagV.mas_width);
    }];
    
    
    
    return self;
}
-(void)layoutSubviews{
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.masksToBounds = YES;
}

-(void)setModel:(LocalImageAndVideoModel *)model{
    _model = model;
    self.imageV.image = model.PHImage;
}

@end
