//
//  OpenTXTEditViewController.m
//  MyFileManage
//
//  Created by Viterbi on 2018/2/2.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "OpenTXTEditViewController.h"
#import "UIViewController+Extension.h"

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
    
    self.textV.text = self.readModel.content;
    self.textV.font = [UIFont systemFontOfSize:15];
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self configurNavBtn];
}

-(void)configurNavBtn{
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self.editBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.editBtn setTitleColor:MAINCOLOR forState:UIControlStateSelected];
    [self.editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addRigthItemWithCustomView:self.editBtn];
}

-(void)editClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    self.textV.editable = sender.isSelected;
    [self.textV becomeFirstResponder];
    // 点击完成的时候
    if (!sender.isSelected) {
        self.readModel.content = self.textV.text;
        [self showMessageWithTitle:@"正在更新"];
        [GCDQueue executeInGlobalQueue:^{
            [LSYReadModel updateContentWithModel:self.readModel url:[NSURL fileURLWithPath:self.model.fullPath]];
            [GCDQueue executeInMainQueue:^{
                [self hidenMessage];
                [self showSuccessWithTitle:@"更新完毕"];
            }];
        }];
    }
}

@end
