//
//  BRNavigationController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRNavigationController.h"

@interface BRNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
/** 自定义导航栏的返回按钮 */
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation BRNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置导航栏背景颜色
    self.navigationBar.barTintColor = kNavBarColor;
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    // 此行代码能将状态栏和导航栏字体颜色全体改变,只能是黑色或白色
    self.navigationBar.barStyle = UIBarStyleBlack;
    
    // 2.设置导航栏所有子视图（返回图片）的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // 3.设置 title 颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.backIndicatorImage = [UIImage new];
    
    // 将系统默认的返回按钮设置到导航栏可见区域外（防止与自定义的返回按钮重叠）
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    
    self.delegate = self;
}

#pragma mark - 重写父类导航控制器的push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断非根视图控制器
    if (self.viewControllers.count > 0) {
        // 设置导航栏左上角的返回按钮 (非根控制器才需要设置返回按钮)
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
        // 隐藏底部的工具条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 执行跳转
    [super pushViewController:viewController animated:animated];
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.bounds = CGRectMake(0, 0, 40, 40);
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"navbar_return"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"navbar_return"] forState:UIControlStateHighlighted];
        [_backButton sizeToFit]; // 图片自动适应按钮大小
        //设置按钮的内边距的偏移量(上，左，下，右), 调整返回箭头离屏幕的左边距
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
        [_backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)clickBackButton {
    [self popViewControllerAnimated:YES];
}

#pragma mark - 重写跳转到指定控制器
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for(UIViewController *vc in self.viewControllers) {
        [vcs addObject:vc];
        if([vc isKindOfClass:[viewController class]]) {
            [super popToViewController:vc animated:animated];
            break;
        }
    }
    return vcs;
}

#pragma mark -- 实现UINavigationController的代理方法
// 解决自定义TabBar使用popToViewController:后出现TabBar重叠/选择状态不切换等Bug
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    // 删除系统自带的tabBarButton
    for (UIView *view in self.tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
/**
 *  因为修改了系统的返回按钮，所以还需要设置手势事件
 *  手势识别对象会调用这个代理方法来决定手势是否有效
 *
 *  @return YES : 手势有效， NO : 手势无效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 当前导航控制器的子控制器有2个以上的时候,手势有效
    return self.childViewControllers.count > 1;
}

@end
