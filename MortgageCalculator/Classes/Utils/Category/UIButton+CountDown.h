//
//  UIButton+CountDown.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/25.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CountDown)

/*
 *    倒计时按钮
 *
 *    @param seconds          要倒计时的总秒数
 *    @param color            还没倒计时的颜色
 *    @param countDownColor   倒计时的颜色
 */
- (void)startWithTime:(NSInteger)seconds color:(UIColor *)color countDownColor:(UIColor *)countDownColor;

@end
