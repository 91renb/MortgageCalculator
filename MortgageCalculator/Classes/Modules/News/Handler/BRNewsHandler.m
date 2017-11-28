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
    NSString *timestamp = [NSDate currentTimestamp];
    // 临时标记
    NSString *nonce = [NSString stringWithFormat:@"sfdyuiy%@", [timestamp substringFromIndex:timestamp.length - 2]];
    NSDictionary *params = @{@"nonce": nonce, @"offset": @(pageOffset), @"count": @(pageSize), @"timestamp": timestamp};
    [HttpTool getWithUrl:API_NewsList params:params success:^(id responseObject) {
        NSLog(@"资讯：%@", responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SuccessFlag) {
            success([BRNewsListModel parse:responseObject[@"result"]]);
        } else {
            failed(@"请求失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"请求错误：%@", error);
        failed(@"请求错误");
    }];
}

@end
