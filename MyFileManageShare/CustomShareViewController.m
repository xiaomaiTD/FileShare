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
  

  [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
    [obj.attachments enumerateObjectsUsingBlock:^(NSItemProvider *  _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
      
//      NSLog(@"itemProvider-------%@",itemProvider);
      
      if ([itemProvider.registeredTypeIdentifiers containsObject:@"public.url"]) {
        [itemProvider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
          
            //group.wangchao.MyFileManageShareExtension
            NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.wangchao.MyFileManageShareExtension"];
            
            NSURL *url = (NSURL *)item;
//            NSLog(@"item-------%@",url.absoluteString);
//
            [userDefaults setValue:url.absoluteString forKey:@"share-pdf-url"];
            [userDefaults setBool:YES forKey:@"has-new-pdf"];
            [userDefaults synchronize];
            
//            NSLog(@"share-pdf-url--------%@",[userDefaults objectForKey:@"share-pdf-url"]);
//
//
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

        }];
      }
      
    }];
    
  }];
    
  
}


@end
