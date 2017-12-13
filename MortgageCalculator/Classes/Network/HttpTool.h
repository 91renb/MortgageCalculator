//
//  HttpTool.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 成功的回调 */
typedef void (^BRHttpSuccessBlock)(id responseObject);
/** 失败的回调 */
typedef void (^BRHttpFailureBlock)(NSError *error);

@interface HttpTool : NSObject

/**
 *  get请求
 *
 *  @param url              请求地址
 *  @param params           请求参数  (NSDictionary类型)
 *  @param successBlock     请求成功的回调  (返回NSDictionary 或 NSArray)
 *  @param failureBlock     请求失败的回调  (返回NSError)
 */

+ (void)getWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(BRHttpSuccessBlock)successBlock
           failure:(BRHttpFailureBlock)failureBlock;

/**
 *  post网络请求
 *
 *  @param url              请求地址
 *  @param params           请求参数  (NSDictionary类型)
 *  @param successBlock     请求成功的回调  (返回NSDictionary 或 NSArray)
 *  @param failureBlock     请求失败的回调  (返回NSError)
 */

+ (void)postWithUrl:(NSString *)url
             params:(NSDictionary *)params
            success:(BRHttpSuccessBlock)successBlock
            failure:(BRHttpFailureBlock)failureBlock;

/**
 *  下载图片(使用YYWebImage)，不给imageView赋值
 *
 *  @param url       图片地址
 *  @param success   下载成功
 *  @param failed    下载失败
 */

+ (void)br_downloadImageWithUrl:(NSString *)url
                       progress:(void(^)(CGFloat progress))progress
                        success:(void(^)(UIImage *image))success
                         failed:(void(^)(NSError *error))failed;

@end
