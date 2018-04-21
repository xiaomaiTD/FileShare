//
//  FolderCell.m
//  MyFileManage
//
//  Created by Viterbi on 2018/1/18.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "FolderCell.h"
#import "PDFDocument.h"
#import "ResourceFileManager.h"


@implementation FolderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.folderImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.folderImage.contentMode = UIViewContentModeScaleAspectFit;
        self.folderImage.image = [UIImage imageNamed:@"文件夹"];
        [self.contentView addSubview:self.folderImage];
        [self.folderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.right.mas_offset(-20);
            make.left.mas_offset(20);
            make.height.mas_offset(100);
        }];
        

        self.textView = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textView.numberOfLines = 0;
        self.textView.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.folderImage.mas_bottom);
            make.right.mas_offset(-20);
            make.left.mas_offset(20);
            make.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

-(void)longPress:(UILongPressGestureRecognizer *)logPress{
    if (logPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(folderCellLongPressWithModel:)]) {
            [self.delegate folderCellLongPressWithModel:self.model];
        }
    }
}

-(void)setModel:(fileModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.textView.text = _model.fileName;
    if (model.isVideo) {
        self.folderImage.image = [UIImage imageNamed:@"视频文件"];
        VLCMedia *media = [VLCMedia mediaWithPath:model.fullPath];
        self.thumbnailer = [VLCMediaThumbnailer thumbnailerWithMedia:media andDelegate:self];
        [self.thumbnailer fetchThumbnail];
    }else if (model.isPhoto){
        self.folderImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:model.fullPath]];
    }else if (model.isPdf){
        PDFDocument *document = [[ResourceFileManager shareInstance].documentStore documentAtPath:model.fullPath];
        self.folderImage.image = document.thumbnailSyncImage ? document.thumbnailSyncImage : [UIImage imageNamed:@"PDF文件"];
    }else if (model.isTxt){
        self.folderImage.image = [UIImage imageNamed:@"文本"];
    }else if (model.isOA){
        self.folderImage.image = [UIImage imageNamed:@"办公"];
    }else if (model.isMusic){
        self.folderImage.image = [UIImage imageNamed:@"音频"];
    }else if (model.isHtml){
        self.folderImage.image = [UIImage imageNamed:@"html"];
    }else if (model.isZip){
        self.folderImage.image = [UIImage imageNamed:@"压缩文件"];
    }else if(model.isFolder){
        self.folderImage.image = [UIImage imageNamed:@"文件夹"];
    }else{
        self.folderImage.image = [UIImage imageNamed:@"未知类型"];
    }
}

-(void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    self.folderImage.image = [UIImage imageNamed:@"视频文件"];
}

-(void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    self.folderImage.image = [UIImage imageWithCGImage:thumbnail];
}

@end
