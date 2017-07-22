//
//  MenuAndNavBarView.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/7/22.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "MenuAndNavBarView.h"



@interface MenuAndNavBarView()



@end

@implementation MenuAndNavBarView



static MenuAndNavBarView *menAndNaView;


+(void)MenuAndNavBarShow{



    




}


+(instancetype)shareInstance{



    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
    });

    return menAndNaView;



}

-(instancetype)initWithFrame:(CGRect)frame{



    if (self = [super initWithFrame:frame]) {
        
        
        
        
        
        
    }

    return self;


}


@end
