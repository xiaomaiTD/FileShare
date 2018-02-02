//
//  OpenTXTEditViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/2.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "OpenTXTEditViewController.h"

@interface OpenTXTEditViewController ()

@property(nonatomic,strong)UITextView *textV;
@property(nonatomic,strong)UIButton *editBtn;
@end

@implementation OpenTXTEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textV = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textV.editable = NO;
    [self.view addSubview:self.textV];
    
    self.textV.text = self.model.content;
    self.textV.font = [UIFont systemFontOfSize:15];
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)configurNavBtn{
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame = CGRectMake(0, 0, 40, 40)
}

@end
