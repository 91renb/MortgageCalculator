//
//  BaseViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import <IQKeyboardManager.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB_HEX(0xF1F1F1, 1.0);
    // 取消自动调整滚动视图间距 (ViewController + Nav 下会自动调整 tableView 的 contentInset)
    self.automaticallyAdjustsScrollViewInsets = NO; // 自动滚动调整，默认为YES
    // 导航栏右滑返回手势
    //self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // 键盘统一收回处理
    [self configureBoardManager];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘收回管理
- (void)configureBoardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    manager.enable = YES;
    // 控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    // 控制键盘上的工具条文字颜色是否用户自定义
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField = 100 * kScaleFit;
    // 控制是否显示键盘上的工具条
    manager.enableAutoToolbar = YES;
}

/**
 *  改变状态栏颜色的两种情况：
 *    1.有导航栏时，
 *          // 将【状态栏】和【导航栏】字体颜色全变为白色（此行代码只能作用于有导航栏的视图控制器下）
 *          self.navigationBar.barStyle = UIBarStyleBlack;
 *    2.没有导航栏/隐藏导航栏时，此方法(preferredStatusBarStyle)才会起作用。不然不能作用到当前的视图控制器上
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    // 销毁当前网络请求
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
