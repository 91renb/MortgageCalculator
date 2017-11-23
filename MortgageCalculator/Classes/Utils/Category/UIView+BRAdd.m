//
//  UIView+BRAdd.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIView+BRAdd.h"

@implementation UIView (BRAdd)
#pragma mark - 给UIView添加渐变背景色
- (void)setGradientColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    //  CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0, @1];
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];
}

@end
