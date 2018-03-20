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


- (void)viewDidLoad{
    
//    self.textView.hidden = YES;
    
//    NSLog(@"class-------%@",self.textView.sub)


    for (UIView *subview in self.textView.superview.superview.superview.superview.subviews) {
        
        NSLog(@"class-------%@",subview.classForCoder);
        subview.hidden = YES;
    }
}

-(void)presentationAnimationDidFinish{
    
//    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
//
//    UIResponder* responder = self;
//    NSString *urlString = @"Demo://";
//    while ((responder = [responder nextResponder]) != nil)
//    {
//        NSLog(@"responder = %@", responder);
//        if([responder respondsToSelector:@selector(openURL:)] == YES)
//        {
//            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:urlString]];
//        }
//    }
//
    
}

- (BOOL)isContentValid {
  
    return YES;
}

- (void)didSelectCancel{
  

}

- (NSArray *)configurationItems {
    return nil;
}

@end
