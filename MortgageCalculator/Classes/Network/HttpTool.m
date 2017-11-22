//
//  HttpTool.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>
#import <UIImageView+YYWebImage.h>

/** 请求超时时间 */
static NSTimeInterval requestTimeout = 20.0f;

@implementation HttpTool
+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 创建请求管理者对象
        manager = [AFHTTPSessionManager manager];
        // 设置请求参数的格式：二进制格式
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // 设置服务器返回结果的格式：JSON格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 设置请求超时时间
        manager.requestSerializer.timeoutInterval = requestTimeout;
        // 配置响应序列化(设置请求接口回来的时候支持什么类型的数据，设置接收参数类型。添加服务器返回的数据格式)
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"text/json",
                                                             @"text/plain",
                                                             @"text/javascript",
                                                             @"text/xml",
                                                             @"image/*",
                                                             @"application/octet-stream",
                                                             @"application/zip",
                                                             @"text/text", nil];
    });
    return manager;
}

#pragma mark - get请求
+ (void)getWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(BRHttpSuccessBlock)successBlock
           failure:(BRHttpFailureBlock)failureBlock {
    // 获取完整的url路径
    NSString *path = nil;
    if ([url hasPrefix:@"http"]) {
        path = url;
    } else {
        path = [AppBaseUrl stringByAppendingPathComponent:url];
    }
    // 开始请求
    [[self sharedManager] GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

#pragma mark - post请求
+ (void)postWithUrl:(NSString *)url
             params:(NSDictionary *)params
            success:(BRHttpSuccessBlock)successBlock
            failure:(BRHttpFailureBlock)failureBlock {
    // 获取完整的url路径
    NSString *path = nil;
    if ([url hasPrefix:@"http"]) {
        path = url;
    } else {
        path = [AppBaseUrl stringByAppendingPathComponent:url];
    }
    // 开始请求
    [[self sharedManager] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

#pragma mark - 下载图片(使用YYWebImage)，不给imageView赋值
+ (void)br_downloadImageWithUrl:(NSString *)url
                       progress:(void(^)(CGFloat progress))progress
                        success:(void(^)(UIImage *image))success
                         failed:(void(^)(NSError *error))failed {
    // YYWebImageOptionAvoidSetImage 下载完图片后不给ImageView赋值，需要我们手动去赋值。
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionAvoidSetImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progress(receivedSize / (expectedSize * 1.0));
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            failed(error);
        } else {
            success(image);
        }
    }];
}

@end

#pragma mark - NSDictionary, NSArray的分类
/*
 ************************************************************************************
 * 新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (BR)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (BR)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif
