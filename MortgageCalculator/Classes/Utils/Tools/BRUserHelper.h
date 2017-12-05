//
//  BRUserHelper.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRUserHelper : NSObject
#pragma mark - 保存信息到偏好设置
/** 保存当前APP的版本号 */
+ (void)setRunVersion:(NSString *)runVersion;
/** 获取保存的APP版本号 */
+ (NSString *)runVersion;

/** 广告图片 */
+ (void)setAdvertImageUrl:(NSString *)advertImageUrl;
+ (NSString *)advertImageUrl;

/** 保存 token */
+ (void)setToken:(NSString *)token;
/** 获取 token */
+ (NSString *)token;

/** 保存 用户ID */
+ (void)setUserID:(NSString *)userID;
/** 获取 用户ID */
+ (NSString *)userID;

/** 保存 用户名/手机号 */
+ (void)setUsername:(NSString *)username;
/** 获取 用户名/手机号 */
+ (NSString *)username;

/** 保存 密码 */
+ (void)setPwd:(NSString *)pwd;
/** 获取 密码 */
+ (NSString *)pwd;

/** 保存 初始化身份 */
+ (void)setIdentityFlag:(NSString *)identityFlag;
/** 获取 初始化身份 */
+ (NSString *)identityFlag;

+ (void)setMySwitch:(BOOL)mySwitch;
+ (BOOL)mySwitch;

/** 清除沙盒中所有用户信息 */
+ (void)removeAllInfo;

@end
