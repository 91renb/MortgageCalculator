//
//  AppDelegate.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "BRUserHelper.h"
#import "BRTabBarController.h"
#import "AppDelegate+Push.h"
#import <BmobSDK/Bmob.h>
#import "BRLaunchingViewController.h"
#import "NSBundle+Language.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 配置网络状态监控
    [self configNetworkStateMonitoring];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"] isEqualToString:@""]) {
        [NSBundle setLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"]];
    }
    
    // 设置根视图控制器
    self.window.rootViewController = [[BRLaunchingViewController alloc]init];
    
    // 注册极光推送
    [self setJupsh:launchOptions];
    
    // 注册云服务（Bmob账号：fdjsqios@163.com / fdjsqios123）
    [Bmob registerWithAppKey:BmobAppID];
    
    return YES;
}

#pragma mark - 设置根视图控制器
- (void)setupRootViewController {
    self.window.rootViewController = [[BRTabBarController alloc]initWithDefaultSelIndex:0];
}

#pragma mark - 懒加载 window
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc]initWithFrame:SCREEN_BOUNDS];
        _window.backgroundColor = [UIColor whiteColor];
        // 让当前UIWindow变成keyWindow，并显示出来
        [_window makeKeyAndVisible];
    }
    return _window;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


#pragma mark -- 点击通知中心里面的远程推送，使App从后台进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
