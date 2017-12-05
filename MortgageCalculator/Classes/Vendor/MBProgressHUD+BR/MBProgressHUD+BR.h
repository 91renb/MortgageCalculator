//
//  MBProgressHUD+BR.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (BR)

#pragma mark - 显示在当前显示的页面上
/** 纯文字提示，1秒后自动消失 */
+ (void)showMessage:(NSString *)message;
/** 纯文字提示，手动设置消失时间 */
+ (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

/** 加载状态+文字提示，手动隐藏提示 */
+ (void)showLoading:(NSString *)message;
/** 加载状态+文字提示，手动设置消失时间 */
+ (void)showLoading:(NSString *)message afterDelay:(NSTimeInterval)delay;

/** 显示成功（图标+文字）提示 */
+ (void)showSuccess:(NSString *)Message;
/** 显示错误（图标+文字）提示 */
+ (void)showError:(NSString *)Message;
/** 显示警告（图标+文字）提示 */
+ (void)showWarn:(NSString *)Message;
/** 显示信息（图标+文字）提示 */
+ (void)showInfo:(NSString *)Message;
/** 显示 自定义图标+文字 提示 */
+ (void)showIcon:(NSString *)iconName message:(NSString *)message;

/** 隐藏提示 */
+ (void)hideHUD;

@end
