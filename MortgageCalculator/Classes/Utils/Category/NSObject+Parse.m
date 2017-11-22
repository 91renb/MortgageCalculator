//
//  NSObject+Parse.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "NSObject+Parse.h"
#import <MJExtension.h>

@implementation NSObject (Parse)
#pragma mark - MJExtension是从模型(属性名) <-> JSON数据(key)
+ (id)parse:(id)responseObj {
    if ([responseObj isKindOfClass:[NSArray class]]) {
        return [self mj_objectArrayWithKeyValuesArray:responseObj];
    }
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:responseObj];
    }
    return responseObj;
}

@end
