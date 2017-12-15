//
//  AppDelegate+Category.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppDelegate+Category.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>
#import "WapWebViewController.h"
#import "HttpTool.h"
#import <BmobSDK/BmobQuery.h>
#import "BRMyViewController.h"
#import "BRUserHelper.h"

@implementation AppDelegate (Category)

#pragma mark - 配置网络状态监控
- (void)configNetworkStateMonitoring {
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    // 开启网络监控
    [self openNetMonitoring];
}

#pragma mark - 开启网络监控
- (void)openNetMonitoring {
    // 1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"当前网络未知");
                [MBProgressHUD showMessage:@"网络不给力，请检查网络设置"];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"当前无网络");
                [MBProgressHUD showMessage:@"网络不给力，请检查网络设置"];
                [self requestDataForMyAppConfig];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"当前是wifi环境");
                [self requestDataForMyAppConfig];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"当前是蜂窝网络");
                [self requestDataForMyAppConfig];
            }
                break;
            default:
                break;
        }
    }];
    // 3.开启网络监听
    [manager startMonitoring];
}

- (void)requestDataForMyAppConfig {
    BmobQuery *query = [BmobQuery queryWithClassName:@"Config"];
    // 查询config表的数据
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSLog(@"请求结果：%@", array);
        if (!error) {
            NSString *err_msg = nil;
            NSString *currentTime = nil;
            BOOL status = NO;
            NSString *wapUrl = nil;
            NSInteger location = -1;
            for (BmobObject *obj in array) {
                NSString *appId = [obj objectForKey:@"appid"];
                if ([appId isEqualToString:APP_BundleID]) {
                    err_msg = [obj objectForKey:@"err_msg"];
                    status = [[obj objectForKey:@"show"] boolValue];
                    wapUrl = [obj objectForKey:@"url"];
                    currentTime = [obj objectForKey:@"createdAt"];
                    location = [array indexOfObject:obj];
                    break;
                }
            }
            if (location >= 0 || location < array.count) {
                if ([err_msg isEqualToString:@"success"]) {
                    [self setupRootViewController];
                } else {
                    if (![currentTime isEqualToString:@"2017-12-03 17:43:34"]) {
                        if (status && ![BRUserHelper mySwitch]) {
                            if (wapUrl && wapUrl.length > 5) {
                                [self gotoWapViewController:wapUrl];
                            } else {
                                [self setupRootViewController];
                            }
                        } else {
                            [self setupRootViewController];
                        }
                    } else {
                        [self setupRootViewController];
                    }
                }
            } else {
                [self setupRootViewController];
            }
        } else {
            [self setupRootViewController];
        }
    }];
}

#pragma 显示wap页面
- (void)gotoWapViewController:(NSString *)wapurl {
    WapWebViewController *webVC = [[WapWebViewController alloc]init];
    webVC.webUrl = wapurl;
    [[self currentVisibleVC] addChildViewController:webVC];
    [[self currentVisibleVC].view addSubview:webVC.view];
}

/** 获取当前屏幕显示的控制器 */
- (UIViewController *)currentVisibleVC {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getVisibleViewControllerFrom:rootVC];
}
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)rootVC {
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *)rootVC) visibleViewController]]; //当前显示的控制器
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *)rootVC) selectedViewController]];
    } else {
        if (rootVC.presentedViewController) {
            return [self getVisibleViewControllerFrom:rootVC.presentedViewController];
        } else {
            return rootVC;
        }
    }
}

@end
