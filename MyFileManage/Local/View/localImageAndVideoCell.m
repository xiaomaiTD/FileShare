//
//  localImageAndVideoCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/24.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "localImageAndVideoCell.h"
#import "maskLocalView.h"
#import <PhotosUI/PHLivePhotoView.h>

@interface localImageAndVideoCell()

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIImageView *videoImagV;
@property(nonatomic,strong)UILabel *videoLength;
@property(nonatomic,strong)UIImageView *livePhotoImagV;
@property(nonatomic,strong)maskLocalView *maskView;

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

        self.livePhotoImagV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.livePhotoImagV];
        [self.livePhotoImagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(5);
            make.top.mas_offset(5);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
        self.videoImagV = [[UIImageView alloc] init];
        self.videoImagV.image = [UIImage imageNamed:@"video"];
        self.videoImagV.contentMode = UIViewContentModeCenter;
        [self addSubview:self.videoImagV];
        
        self.videoLength = [[UILabel alloc] initWithFrame:CGRectZero];
        self.videoLength.textColor = [UIColor whiteColor];
        self.videoLength.font = [UIFont systemFontOfSize:12];
        self.videoLength.text = @"text";
        self.videoLength.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.videoLength];
        
        self.maskView = [[maskLocalView alloc] initWithFrame:CGRectZero];
        self.maskView.hidden = YES;
        [self addSubview:self.maskView];
      
        [self.videoImagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.left.mas_offset(0);
            make.right.equalTo(self.videoLength.mas_left).mas_offset(0);
            make.height.mas_equalTo(20);
            make.width.equalTo(self.videoLength.mas_width);
        }];
        [self.videoLength mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.right.mas_offset(0);
            make.left.equalTo(self.videoImagV.mas_right).mas_offset(0);
            make.height.mas_equalTo(20);
        }];
        
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
-(void)layoutSubviews{
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.masksToBounds = YES;
}

-(void)setModel:(LocalImageAndVideoModel *)model{
    _model = model;
    self.imageV.image = model.PHImage;
    self.videoLength.text = model.videoLength;
    self.maskView.hidden = !model.selected;
    
    self.livePhotoImagV.hidden = NO;
    self.videoImagV.hidden = NO;
    self.videoLength.hidden = NO;
    switch (model.type) {
        case PHASSETTYPE_Video:
        {
            self.livePhotoImagV.hidden = YES;
        }
            break;
        case PHASSETTYPE_Image:
        {
            self.livePhotoImagV.hidden = YES;
            self.videoImagV.hidden = YES;
            self.videoLength.hidden = YES;
        }
            break;
        case PHASSETTYPE_LivePhoto:
        {
            self.videoImagV.hidden = YES;
            self.videoLength.hidden = YES;
        }
            break;
        default:
            break;
    }
    if (PHASSETTYPE_LivePhoto) {
        self.livePhotoImagV.image = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
    }

}

@end
