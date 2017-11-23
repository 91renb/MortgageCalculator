//
//  BRTabBarController.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRTabBarController : UITabBarController

/**
 *  数字角标
 *
 *  @param badge   所要显示数字
 *  @param index   位置
 */
- (void)showBadgeMark:(NSInteger)badge index:(NSInteger)index;

/**
 *  小红点
 *
 *  @param index 位置
 */
- (void)showPointMarkIndex:(NSInteger)index;

/**
 *  隐藏指定位置角标
 *
 *  @param index 位置
 */
- (void)hideMarkIndex:(NSInteger)index;

@end
