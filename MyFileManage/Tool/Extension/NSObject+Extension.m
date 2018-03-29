//
//  NSObject+firstLeap.m
//  firstleapKit
//
//  Created by Viterbi on 2017/10/13.
//  Copyright © 2017年 firstLeap. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import <sys/utsname.h>

static const int block_key;

@interface _FirstLeapKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(__weak id obj, id oldVal, id newVal);

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block;

@end

@implementation _FirstLeapKVOBlockTarget

- (id)initWithBlock:(void (^)(__weak id obj, id oldVal, id newVal))block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!self.block) return;
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldVal == [NSNull null]) oldVal = nil;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    self.block(object, oldVal, newVal);
}

@end


@implementation NSObject (Extension)

-(NSString *)valueToJson
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
    
}
-(NSArray *)firstleap_map:(id (^)(id))block
{
    if ([self isKindOfClass:[NSArray class]]) {
        NSMutableArray *newArray = [NSMutableArray array];
        [(NSArray *)self enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
            id obj = block(item);
            if (obj) {
                [newArray addObject:obj];
            }
        }];
        return newArray;
    }
    return @[].copy;
}

-(NSArray *)firstleap_filter:(BOOL (^)(id))block
{
    if ([self isKindOfClass:[NSArray class]]) {
        NSMutableArray *newArray = [NSMutableArray array];
        [(NSArray *)self enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
            if (block(item)) {
                [newArray addObject:item];
            }
        }];
        return newArray;
    }
    return @[].copy;
}

-(void)addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block {
    if (!keyPath || !block) return;
    _FirstLeapKVOBlockTarget *target = [[_FirstLeapKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self _allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    if (!arr) {
        arr = [NSMutableArray new];
        dic[keyPath] = arr;
    }
    [arr addObject:target];
    [self addObserver:target forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

-(void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    if (!keyPath) return;
    NSMutableDictionary *dic = [self _allNSObjectObserverBlocks];
    NSMutableArray *arr = dic[keyPath];
    [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:obj forKeyPath:keyPath];
    }];
    
    [dic removeObjectForKey:keyPath];
}

-(void)removeObserverBlocks {
    NSMutableDictionary *dic = [self _allNSObjectObserverBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}

-(NSMutableDictionary *)_allNSObjectObserverBlocks {
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

-(BOOL)isNotBlank{
    
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSMutableString class]]) {
        NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        for (NSInteger i = 0; i < [(NSString *)self length]; ++i) {
            unichar c = [(NSString *)self characterAtIndex:i];
            if (![blank characterIsMember:c]) {
                return YES;
            }
        }
        return NO;
    }
    return NO;
}

- (BOOL)containsString:(NSString *)string {
    if (![self isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (string == nil) return NO;
    return [(NSString *)self rangeOfString:string].location != NSNotFound;
}

+(NSString *)stringWithUUID{
    
    if ([self isKindOfClass:[NSString class]]) {
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        return (__bridge_transfer NSString *)string;
    }
    
    return nil;
}
@end
