//
//  localCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/23.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "localCell.h"
#import "ImageManager.h"

@implementation localCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    self.firstImagV = [[UIImageView alloc] init];
    self.firstImagV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.firstImagV];
    [self.firstImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self);
        make.size.width.and.height.mas_equalTo(80);
    }];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectZero];
    self.name.font = [UIFont systemFontOfSize:13];
    self.name.text = @"相册";
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstImagV.mas_right).mas_offset(20);
        make.top.equalTo(self.firstImagV.mas_top).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    self.count = [[UILabel alloc] initWithFrame:CGRectZero];
    self.count.font = [UIFont systemFontOfSize:13];
    self.count.text = @"总数：15";
    [self addSubview:self.count];
    [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstImagV.mas_right).mas_offset(20);
        make.top.equalTo(self.name.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    [self addSubview:rightArrow];
    
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(20, 20));
        make.right.mas_offset(-20);
    }];
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectZero];
    lineLable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.size.height.mas_offset(1);
    }];
}

-(void)layoutSubviews{
    self.firstImagV.layer.cornerRadius = 5;
    self.firstImagV.layer.masksToBounds = YES;
}

-(void)setLocalImage:(LocalImageModel *)localImage{
    self.name.text = localImage.title;
    self.count.text = [NSString stringWithFormat:@"%ld",(long)localImage.count];
    NSLog(@"localImage-----%@",localImage.image);
    //album
    self.firstImagV.image = localImage.image == nil ? [UIImage imageNamed:@"album"] : localImage.image;
    _localImage = localImage;
}


@end
