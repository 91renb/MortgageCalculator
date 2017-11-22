//
//  BRUserHelper.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRUserHelper.h"

#define defaults [NSUserDefaults standardUserDefaults]

static NSString *const runVersionKey = @"runVersion";
static NSString *const advertImageUrlKey = @"advertImageUrl";
static NSString *const tokenKey = @"token";
static NSString *const userIDKey = @"userID";
static NSString *const usernameKey = @"username";
static NSString *const pwdKey = @"pwd";
static NSString *const identityFlagKey = @"identityFlag";

@implementation BRUserHelper
// 存入方法
+ (void)setRunVersion:(NSString *)runVersion {
    [defaults setObject:runVersion forKey:runVersionKey];
    [defaults synchronize];
}

+ (void)setAdvertImageUrl:(NSString *)advertImageUrl {
    [defaults setObject:advertImageUrl forKey:advertImageUrlKey];
    [defaults synchronize];
}

+ (void)setToken:(NSString *)token {
    [defaults setObject:token forKey:tokenKey];
    [defaults synchronize];
}

+ (void)setUserID:(NSString *)userID {
    [defaults setObject:userID forKey:userIDKey];
    [defaults synchronize];
}

+ (void)setUsername:(NSString *)username {
    [defaults setObject:username forKey:usernameKey];
    [defaults synchronize];
}

+ (void)setPwd:(NSString *)pwd {
    [defaults setObject:pwd forKey:pwdKey];
    [defaults synchronize];
}

+ (void)setIdentityFlag:(NSString *)identityFlag {
    [defaults setObject:identityFlag forKey:identityFlagKey];
    [defaults synchronize];
}


// 取出方法
+ (NSString *)runVersion {
    return [defaults objectForKey:runVersionKey];
}

+ (NSString *)advertImageUrl {
    return [defaults objectForKey:advertImageUrlKey];
}

+ (NSString *)token {
    return [defaults objectForKey:tokenKey];
}

+ (NSString *)userID {
    return [defaults objectForKey:userIDKey];
}

+ (NSString *)username {
    return [defaults objectForKey:usernameKey];
}

+ (NSString *)pwd {
    return [defaults objectForKey:pwdKey];
}

+ (NSString *)identityFlag {
    return [defaults objectForKey:identityFlagKey];
}

// 删除所有信息
+ (void)removeAllInfo {
    //[defaults removeObjectForKey:tokenKey];
    //[defaults synchronize];
}

@end
