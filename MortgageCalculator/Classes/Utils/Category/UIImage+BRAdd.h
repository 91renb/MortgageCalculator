//
//  UIImage+BRAdd.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BRAdd)
/** 用颜色返回一张图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/** 设置图片的透明度 */
- (UIImage *)alpha:(CGFloat)alpha;

/** 切圆角，使用绘图技术 */
- (UIImage *)circleImage;

/** UIImage 转换成 base64字符串 */
- (NSString *)base64String;

/** base64 字符串转 UIImage图片 */
+ (UIImage *)imageWithBase64String:(NSString *)base64String;

@end
