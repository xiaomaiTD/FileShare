//
//  common.h
//  MyFileManage
//
//  Created by Viterbi on 2018/1/16.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#ifndef common_h
#define common_h

#define FileFinish @"FileFinish"
#define FileUploadSavePath  [NSString stringWithFormat:@"%@/MyFileManageUpload",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]]
#define SupportPictureArray @[@"PNG",@"JPG",@"GIF",@"JPEG"]
#define SupportVideoArray @[@"MP4",@"RMVB",@"MOV",@"MKV"]
#define SupportTXTArray @[@"TXT",@"EPUB"]
#define SupportMusicArray @[@"MP3",@"WMA",@"WAV"]
#define SupportOAArray @[@"HTML",@"NUMBERS",@"DOC",@"DOCX",@"XLSX",@"XLS",@"XLSM",@"PPT",@"PPTX",@"PPS",@"PPA",@"PAGES",@"KEY"]
#define SupportZIPARRAY @[@"ZIP",@"RAR"]
#define VideoSliderChange @"VideoSliderChange"

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* common_h */
