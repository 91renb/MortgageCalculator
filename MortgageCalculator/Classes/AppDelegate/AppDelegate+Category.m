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

#pragma mark - 获取自定义的APP设置信息
- (void)requestDataForMyAppConfig {
    BmobQuery *query = [BmobQuery queryWithClassName:@"config"];
    // 查询config表的数据
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            NSString *showFlag = nil;
            NSString *showText = nil;
            for (BmobObject *obj in array) {
                NSString *appId = [obj objectForKey:@"appId"];
                if ([appId isEqualToString:APP_BundleID]) {
                    // showFlag: 0 送审中  1 审核成功 2 自定义状态
                    showFlag = [obj objectForKey:@"show"];
                    showText = [obj objectForKey:@"showText"];
                    [BRUserHelper setIdentityFlag:showFlag];
                    break;
                }
            }
            if ([showFlag isEqualToString:App_ReviewingStatus]) {
                // 走送审流程
                [self setupRootViewController:App_ReviewingStatus];
            } else if ([showFlag isEqualToString:App_SuccessStatus]) {
                // 走正常流程
                [self requestDataForAppSettingInfo];
            } else if ([showFlag isEqualToString:App_MyStatus]) {
                // 跳转到自己的页面
                [self showBRMyViewController:showText];
            } else {
                // 没有找到对应的appId
                [self setupRootViewController:App_ReviewingStatus];
            }
        } else {
            NSLog(@"获取我的配置信息失败：%@", error);
            [self setupRootViewController:App_ReviewingStatus];
        }
    }];
}

#pragma mark - 获取app的设置信息
- (void)requestDataForAppSettingInfo {
    NSDictionary *params = @{@"appid": APP_ID};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [HttpTool postWithUrl:API_AppSetting params:params success:^(id responseObject) {
            NSLog(@"获取App设置信息：%@", responseObject);
            NSInteger status = [responseObject[@"status"] integerValue];
            if (status == 1) {
                NSLog(@"获取数据成功");
                NSInteger isshowwap = [responseObject[@"isshowwap"] integerValue];
                //NSString *wapurl = responseObject[@"wapurl"];
                NSString *wapurl = (isshowwap == 1) ? responseObject[@"wapurl"] : @"";
                if (![wapurl isEqualToString:@""]) {
                    // 1.加载wapurl
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self createHtmlViewController:wapurl];
                    });
                } else {
                    // 2.不加载wapurl
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setupRootViewController:App_SuccessStatus];
                    });
                }
            } else if (status == 2) {
                NSLog(@"获取数据失败");
                // 2.不加载wapurl
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupRootViewController:App_SuccessStatus];
                });
            } else {
                // 2.不加载wapurl
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupRootViewController:App_SuccessStatus];
                });
            }
        } failure:^(NSError *error) {
            NSLog(@"请求失败：%@", error);
            // 2.不加载wapurl
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupRootViewController:App_SuccessStatus];
            });
        }];
    });
}

//#pragma mark - 获取自定义的APP设置信息
//- (void)requestDataForMyAppConfig:(NSString *)wapurl {
//    BmobQuery *query = [BmobQuery queryWithClassName:@"config"];
//    NSLog(@"AppID = %@", APP_BundleID);
//    // 查询config表的数据
//    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        if (!error) {
//            NSInteger index = 0;
//            for (BmobObject *obj in array) {
//                NSString *appId = [obj objectForKey:@"appId"];
//                if ([appId isEqualToString:APP_BundleID]) {
//                    // show: 1 跳转  2 不跳转
//                    NSInteger show = [[obj objectForKey:@"show"] integerValue];
//                    if (show == 1) {
//                        // 跳转到自己的页面
//                        [self showBRMyViewController:[obj objectForKey:@"showText"]];
//                    } else {
//                        // 跳转到wap页面
//                        [self createHtmlViewController:wapurl];
//                    }
//                    break;
//                }
//                index++;
//            }
//            if (index == array.count) {
//                // 跳转到wap页面
//                [self createHtmlViewController:wapurl];
//            }
//        } else {
//            NSLog(@"获取我的配置信息失败：%@", error);
//            // 跳转到wap页面
//            [self createHtmlViewController:wapurl];
//        }
//    }];
//}

#pragma 显示wap页面
- (void)createHtmlViewController:(NSString *)wapurl {
    WapWebViewController *webVC = [[WapWebViewController alloc]init];
    webVC.webUrl = wapurl;
    [[UIApplication sharedApplication].keyWindow addSubview:webVC.view];
    [[self currentVisibleVC] addChildViewController:webVC];
}

#pragma mark - 显示自定义页面
- (void)showBRMyViewController:(NSString *)showText {
    BRMyViewController *myVC = [[BRMyViewController alloc]init];
    myVC.showText = showText;
    [[UIApplication sharedApplication].keyWindow addSubview:myVC.view];
    [[self currentVisibleVC] addChildViewController:myVC];
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
