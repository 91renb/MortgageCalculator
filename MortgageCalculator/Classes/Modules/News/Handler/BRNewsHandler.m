//
//  BRNewsHandler.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRNewsHandler.h"
#import "HttpTool.h"
#import "NSObject+Parse.h"
#import "BRNewsListModel.h"
#import "NSString+BRAdd.h"
#import "NSDate+BRAdd.h"

@implementation BRNewsHandler

+ (void)executeNewsListTaskWithPageOffset:(NSInteger)pageOffset pageSize:(NSInteger)pageSize Success:(SuccessBlock)success failed:(FailedBlock)failed {
    // 加载本地数据（实际开发中这里写网络请求，从服务端请求数据...）
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"newsList" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"资讯：%@", responseObject);
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"success"]) {
            NSArray *allModelArr = [BRNewsListModel parse:responseObject[@"result"]];
            NSMutableArray *listModelArr = [NSMutableArray array];
            for (NSInteger i = pageOffset; i < pageOffset + pageSize; i++) {
                if (i < allModelArr.count) {
                    [listModelArr addObject:allModelArr[i]];
                }
            }
            success(listModelArr);
        } else {
            failed(@"请求失败");
        }
    });
}

@end
