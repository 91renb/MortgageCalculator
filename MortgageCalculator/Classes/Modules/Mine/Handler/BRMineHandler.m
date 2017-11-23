//
//  BRMineHandler.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRMineHandler.h"

@implementation BRMineHandler

#pragma mark - 发送手机验证码
+ (void)executeSendMessageCodeTaskWithStringParams:(NSString *)sParams Success:(SuccessBlock)success failed:(FailedBlock)failed {
    // 设置URL路径
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", PhoneMessageCodeUrl, sParams];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // 通过URL设置网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0f];
    NSError *error = nil;
    // 获取服务器数据
    NSData *requestData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (!error) {
        NSString *result = [[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
        NSLog(@"发送手机验证码请求：%@", result);
        if ([result hasPrefix:@"success"]) {
            success(result);
        } else {
            failed(result);
        }
    } else {
        NSLog(@"请求失败:%@", [error localizedDescription]);
        failed([error localizedDescription]);
    }
}

@end
