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


#endif /* common_h */
