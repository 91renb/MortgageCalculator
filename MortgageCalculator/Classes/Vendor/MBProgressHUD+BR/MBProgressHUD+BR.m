//
//  MBProgressHUD+BR.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "MBProgressHUD+BR.h"
#import "AppDelegate+Category.h"

@implementation MBProgressHUD (BR)

+ (MBProgressHUD *)getProgressHUD:(NSString *)message {
    UIView *currentView = [appDelegate currentVisibleVC].view;
    // 弹出新的提示之前,先把旧的隐藏掉
    [self hideHUDForView:currentView animated:YES];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
    // 关闭绘制的"性能开关",如果alpha不为1,最好将opaque设为NO,让绘图系统优化性能
    hud.opaque = NO;
    // 背景方框的颜色
    //hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
    // 将转圈和文字设置成白色
    //hud.contentColor = [UIColor whiteColor];
    // HUD边缘与内部元素的间距
    hud.margin = 15.0f / kScaleFit;
    // 设置显示文字
    //hud.label.font = [UIFont systemFontOfSize:15.0f];
    //hud.label.textAlignment = NSTextAlignmentCenter;
    //hud.label.text = message;
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 屏幕背景是否有遮罩
    //hud.dimBackground = YES;
    
    return hud;
}

#pragma mark - 纯文字提示
+ (void)showMessage:(NSString*)message afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [self getProgressHUD:message];
    // 设置显示模式：纯文本模式
    hud.mode = MBProgressHUDModeText;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0f];
    //[hud hideAnimated:YES afterDelay:1.0f];
}

#pragma mark - 显示 文字 提示
+ (void)showMessage:(NSString *)message {
    [self showMessage:message afterDelay:1.0f];
}

#pragma mark - 显示 加载+文字 提示
+ (void)showLoading:(NSString *)message afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [self getProgressHUD:message];
    // 设置显示模式：菊花转动(默认)
    hud.mode = MBProgressHUDModeIndeterminate;
    if (delay > 0) {
        // 如果设置了消失时间，时间到了就自动消失
        //[hud hideAnimated:YES afterDelay:delay];
        [hud hide:YES afterDelay:1.0f];
    }
}

+ (void)showLoading:(NSString *)message {
    [self showLoading:message afterDelay:30];
}

#pragma mark - 自定义图标 + 文字 提示
+ (void)showIcon:(NSString *)iconName message:(NSString *)message {
    MBProgressHUD *hud  =  [self getProgressHUD:message];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"MBProgressHUD+BR.bundle/MBProgressHUD" stringByAppendingPathComponent:iconName]]];
    // 设置显示模式：自定义视图
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:1.0f];
    //[hud hideAnimated:YES afterDelay:1.0f];
}

#pragma mark - 显示 成功/错误/信息/警告 图标 + 文字 提示
/** 显示 成功图标+文字 提示 */
+ (void)showSuccess:(NSString *)Message {
    [self showIcon:@"hud_success" message:Message];
}

+ (void)showError:(NSString *)Message {
    [self showIcon:@"hud_error" message:Message];
}

+ (void)showWarn:(NSString *)Message {
    [self showIcon:@"hud_warn" message:Message];
}

+ (void)showInfo:(NSString *)Message {
    [self showIcon:@"hud_info" message:Message];
}

#pragma mark - 隐藏提示
+ (void)hideHUD {
    [self hideHUDForView:[appDelegate currentVisibleVC].view animated:YES];
}

@end
