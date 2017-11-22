//
//  AppDelegate+Category.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Category)
/** 配置网络状态监控 */
- (void)configNetworkStateMonitoring;

/** 获取当前屏幕显示的控制器 */
- (UIViewController *)currentVisibleVC;

@end
