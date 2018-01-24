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
    self.firstImagV.backgroundColor = [UIColor redColor];
    self.firstImagV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.firstImagV];
    [self.firstImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.size.with.mas_equalTo(100);
        
    }];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectZero];
    self.name.font = [UIFont systemFontOfSize:13];
    self.name.text = @"相册";
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstImagV.mas_right).mas_offset(20);
        make.top.equalTo(self.firstImagV.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
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
}

-(void)layoutSubviews{
    self.firstImagV.layer.cornerRadius = 5;
    self.firstImagV.layer.masksToBounds = YES;
}

-(void)setLocalImage:(LocalImageModel *)localImage{
    self.name.text = localImage.title;
    self.count.text = [NSString stringWithFormat:@"%ld",(long)localImage.count];
    self.firstImagV.image = localImage.image;
    _localImage = localImage;
}


@end
