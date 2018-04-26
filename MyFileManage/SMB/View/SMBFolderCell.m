//
//  SMBFolderCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/4/21.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "SMBFolderCell.h"

@implementation SMBFolderCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.icomImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"显示文件"]];
        [self addSubview:self.icomImagV];
        [self.icomImagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.equalTo(self);
            make.size.mas_offset(self.icomImagV.size);
        }];
        
        
        self.downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *donloadImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SM_下载"]];
        [self.downLoadBtn setImage:donloadImage.image forState:UIControlStateNormal];
        @weakify(self);
        [self.downLoadBtn addTargetWithBlock:^(UIButton *sender) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(downloadFileCallback:)]) {
                [self.delegate downloadFileCallback:self.file];
            }
        }];
        [self addSubview:self.downLoadBtn];
        [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-20);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(donloadImage.size);
        }];
        
        UIImageView *watchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SM_观看"]];
        self.watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.watchBtn setImage:watchImage.image forState:UIControlStateNormal];
        [self.watchBtn addTargetWithBlock:^(UIButton *sender) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(watchVideoCallback:)]) {
                [self.delegate watchVideoCallback:self.file];
            }
        }];
        [self addSubview:self.watchBtn];
        [self.watchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.downLoadBtn.mas_left).mas_offset(-20);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(watchImage.size);
        }];
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.text = @"";
        self.nameLable.font = [UIFont systemFontOfSize:15];
        self.nameLable.numberOfLines = 0;
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icomImagV.mas_right).offset(10);
            make.top.mas_offset(10);
            make.bottom.mas_offset(-10);
            make.right.equalTo(self.watchBtn.mas_left);
        }];

        
    }
    return self;
}

-(void)setShare:(SMBShare *)share{
    _share = share;
    self.nameLable.text = _share.name;
    self.icomImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"显示文件"]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.watchBtn.hidden = YES;
    self.downLoadBtn.hidden = YES;
}

-(void)setFile:(SMBFile *)file{
    _file = file;
    self.nameLable.text = _file.name;
    self.accessoryType = UITableViewCellAccessoryNone;
    NSString *pathExtension = file.path.pathExtension.uppercaseString;
    NSString *imageName = @"显示文件";
    self.watchBtn.hidden = YES;
    self.downLoadBtn.hidden = NO;
    if ([SupportOAArray containsObject:pathExtension]) {
        imageName = @"SM_办公图标";
    }else if ([SupportTXTArray containsObject:pathExtension]){
        imageName = @"SM_文本";
    }else if ([SupportZIPARRAY containsObject:pathExtension]){
        imageName = @"SM_压缩文件";
    }else if ([SupportVideoArray containsObject:pathExtension]){
        imageName = @"SM_视频";
        self.watchBtn.hidden = NO;
    }else if ([SupportMusicArray containsObject:pathExtension]){
        imageName = @"SM_音乐";
    }else if ([pathExtension isEqualToString:@"PDF"]){
        imageName = @"SM_PDF";
    }else if (file.isDirectory){
        imageName = @"显示文件";
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.watchBtn.hidden = YES;
        self.downLoadBtn.hidden = YES;
    }else if ([SupportPictureArray containsObject:pathExtension]){
        imageName = @"SM_图片";
    }else{
        imageName = @"SM_未知格式";
    }
    self.icomImagV.image = [UIImage imageNamed:imageName];
    
}

@end
