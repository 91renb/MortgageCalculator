//
//  AppDelegate.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//com.apple.br.MortgageCalculator
/** 设置根视图控制器 */
- (void)setupRootViewController:(NSString *)identityFlag;

@end

