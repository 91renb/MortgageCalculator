//
//  NSArray+BRAdd.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "NSArray+BRAdd.h"

@implementation NSArray (BRAdd)
#pragma mark - 数组 转 json字符串
- (NSString *)toJsonString {
    NSError *error = nil;
    // 1.转化为 JSON 格式的 NSData
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"数组转JSON字符串失败：%@", error);
    }
    // 2.转化为 JSON 格式的 NSString
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
