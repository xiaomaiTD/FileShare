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
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.text = @"";
        self.nameLable.font = [UIFont systemFontOfSize:15];
        self.nameLable.numberOfLines = 0;
        [self addSubview:self.nameLable];
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icomImagV.mas_right).offset(10);
            make.top.mas_offset(10);
            make.bottom.mas_offset(-10);
            make.right.mas_offset(-10);
        }];
    }
    return self;
}

-(void)setShare:(SMBShare *)share{
    _share = share;
    self.nameLable.text = _share.name;
    self.icomImagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"显示文件"]];
}

-(void)setFile:(SMBFile *)file{
    _file = file;
    self.nameLable.text = _file.name;
//    file.path.pathExtension
    NSString *pathExtension = file.path.pathExtension.uppercaseString;
    NSString *imageName = @"显示文件";
    if ([SupportOAArray containsObject:pathExtension]) {
        imageName = @"SM_办公图标";
    }else if ([SupportTXTArray containsObject:pathExtension]){
        imageName = @"SM_文本";
    }else if ([SupportZIPARRAY containsObject:pathExtension]){
        imageName = @"SM_压缩文件";
    }else if ([SupportVideoArray containsObject:pathExtension]){
        imageName = @"SM_视频";
    }else if ([SupportMusicArray containsObject:pathExtension]){
        imageName = @"SM_音乐";
    }else if ([pathExtension isEqualToString:@"PDF"]){
        imageName = @"SM_PDF";
    }else if (file.isDirectory){
        imageName = @"显示文件";
    }else{
        imageName = @"SM_未知格式";
    }
    self.icomImagV.image = [UIImage imageNamed:imageName];
    
}

@end
