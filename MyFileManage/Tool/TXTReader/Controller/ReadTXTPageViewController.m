//
//  ReadTXTPageViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/6/14.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "ReadTXTPageViewController.h"
#import "TXTReaderParse.h"



@interface ReadTXTPageViewController ()

@end

@implementation ReadTXTPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView];
    
    
    
    
}




-(ReadTXTView *)textView{


    if (!_textView) {
        
        _textView = [[ReadTXTView alloc] initWithFrame:CGRectMake(16, 16, kScreenWidth-32, kScreenHeight-32)];
        _textView.frameRef = [TXTReaderParse parserContent:_content andBouds:_textView.bounds];
        _textView.content = _content;
        
    }
    
    return _textView;



}





@end
