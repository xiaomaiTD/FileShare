//
//  ShareViewController.m
//  MyFileManageShare
//
//  Created by Viterbi on 2018/3/19.
//  Copyright © 2018年 wangchao. All rights reserved.
//

#import "CustomShareViewController.h"


@interface CustomShareViewController ()

@end

@implementation CustomShareViewController


-(void)viewDidAppear:(BOOL)animated{
  
  UIResponder* responder = self;
  NSString *urlString = @"wangchao.MyFileManageExtension://";
  while ((responder = [responder nextResponder]) != nil)
  {
    NSLog(@"responder = %@", responder);
    if([responder respondsToSelector:@selector(openURL:)] == YES)
    {
      [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:urlString]];
    }
  }
  
  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}


@end
