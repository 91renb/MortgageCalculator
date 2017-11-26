//
//  Macros.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/// 屏幕大小、宽、高
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 当前线程
#define CURRENT_THREAD NSLog(@"当前线程：%@", [NSThread currentThread]);

// 等比例适配系数
#define kScaleFit (SCREEN_WIDTH / 375.0f)

#define SuccessFlag 0


// 状态栏的高度(20 / 44(iPhoneX))
#define STATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
// 标题栏的高度(44)
#define NAVBAR_HEIGHT (self.navigationController.navigationBar.frame.size.height)
/// 导航栏的高度(64 / 88(iPhoneX))
#define NAV_HEIGHT (STATUSBAR_HEIGHT + NAVBAR_HEIGHT)

/// tabbar高度：49 / 83(iPhoneX)
#define TABBAR_HEIGHT ((STATUSBAR_HEIGHT == 44) ? 83 : 49)

#define kThemeColor RGB_HEX(0x46b2f0, 1.0f)

#define kTextDefaultColor RGB_HEX(0x464646, 1.0f)

// 一个像素点
#define LINE_HEIGHT (1 / [UIScreen mainScreen].scale)

/// RGB颜色(10进制)
#define RGB(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

/// RGB颜色(16进制)
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

/// iOS版本号
#define IOS_VERSION [UIDevice currentDevice].systemVersion.doubleValue

/// App版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/// 获取BundleID
#define APP_BundleID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

/// 获取app的名字
#define APP_Name [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

/// AppDelegate 对象
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

/// 本地沙盒目录
#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
#define LIBRARY_PATH NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject
#define TEMP_PATH NSTemporaryDirectory()
//清除缓存用：只清除Caches文件夹下的内容，不清除Preferences文件下的内容(NSUserDefaults)
#define LIBRARY_PATH_CACHE [LIBRARY_PATH stringByAppendingPathComponent:@"Caches"]

/// 保证 #ifdef 中的宏定义只会在 OC 的代码中被引用。否则，一旦引入 C/C++ 的代码或者框架，就会出错！
#ifdef __OBJC__

// 日志输出宏定义
#ifdef DEBUG
// 调试状态
#define NSLog(fmt, ...) NSLog((@" %s [第%d行] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#define NSLog(FORMAT, ...) fprintf(stderr, "【%s:%zd】%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
// 发布状态
#define NSLog(...)
#endif

#endif

#endif /* Macros_h */
