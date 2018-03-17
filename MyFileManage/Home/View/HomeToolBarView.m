//
//  HomeToolBarView.m
//  MyFileManage
//
//  Created by Viterbi on 2018/3/15.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "HomeToolBarView.h"

@interface HomeToolBarView()
@property(nonatomic,strong)NSMutableArray<UIButton *> *btnArray;
@property(nonatomic,strong)UIView *maskView;
@end

@implementation HomeToolBarView

-(NSMutableArray *)btnArray{
    if (_btnArray == nil) {
        _btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _btnArray;
}

-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _maskView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        
        NSArray *imageArray = @[@"move",@"copy",@"delete",@"share",@"sender"];
        for (int i = 0; i<self.btnArray.count; i++) {
            UIButton *btn = self.btnArray[i];
            NSString *imageName = imageArray[i];
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            switch (i) {
                case 0:
                    _moveBtn = btn;
                    break;
                case 1:
                    _fuZhiBtn = btn;
                    break;
                case 2:
                    _deleteBtn = btn;
                    break;
                case 3:
                    _shareBtn = btn;
                    break;
                case 4:
                    _sender = btn;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectZero];
    lineLable.backgroundColor = [UIColor lightGrayColor];
    lineLable.alpha = 0.5;
    [self addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.and.right.mas_offset(0);
        make.size.height.mas_offset(1);
    }];
    
    NSInteger offset = 10;
    UIButton *tempBtn = nil;
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(offset);
                make.top.equalTo(lineLable.mas_bottom).mas_offset(1);
                make.bottom.equalTo(self);
            }];
        }else if (i == 4){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(-offset);
                make.top.equalTo(lineLable.mas_bottom).mas_offset(1);
                make.bottom.equalTo(self);
                make.left.equalTo(tempBtn.mas_right).mas_offset(offset);
                make.width.equalTo(tempBtn);
            }];
            
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempBtn.mas_right).mas_offset(offset);
                make.top.equalTo(lineLable.mas_bottom).mas_offset(1);
                make.bottom.equalTo(self);
                make.width.equalTo(tempBtn);
            }];
        }
        
        tempBtn = btn;
    }
    
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.maskView.alpha = 0.5;
    self.maskView.hidden = YES;
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
  
}

-(void)setHomeBarIsHidden:(BOOL)hidden{
    self.maskView.hidden = hidden;
}

@end
