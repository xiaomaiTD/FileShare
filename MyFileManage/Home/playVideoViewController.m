//
//  playVideoViewController.m
//  MyFileManage
//
//  Created by 掌上先机 on 2017/5/25.
//  Copyright © 2017年 wangchao. All rights reserved.
//

#import "playVideoViewController.h"




@interface playVideoViewController ()


@property(nonatomic,strong)UIView *playView;


@end

@implementation playVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_playView];
    
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
   
   // NSURL *url = [[NSURL alloc] initFileURLWithPath:_model.fullPath];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
