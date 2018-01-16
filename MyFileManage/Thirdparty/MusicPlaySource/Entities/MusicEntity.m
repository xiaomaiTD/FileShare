//
//  MusicEntity.m
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "MusicEntity.h"

@implementation MusicEntity
/*
 "id": 43,
 "title": "Old Memory",
 "artist": "三輪学",
 "pic": "http://aufree.qiniudn.com/images/album/img20/89520/4280541424067346.jpg",
 "music_url" : "http://aufree.qiniudn.com/1770059653_2050944_l.mp3",
 "file_name" : "1770059653_2050944_l",
 "content": "此曲旋律轻快, 美妙, 仿佛欲将人带入一个十分干净且祥和的小镇... "
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name" : @"name",
             @"cover" : @"pic",
             @"artistName" : @"name",
             @"musicUrl" : @"musicUrl",
             @"fileName" : @"name",
             @"fullPath" : @"fullPath"
             };
}

@end
