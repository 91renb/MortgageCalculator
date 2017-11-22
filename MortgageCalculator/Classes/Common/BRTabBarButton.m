//
//  BRTabBarButton.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRTabBarButton.h"

//按钮中图片与文字上下所占比例
static const float scale = 0.7;

@implementation BRTabBarButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 按钮的背景颜色
        self.backgroundColor = [UIColor clearColor];
        // 按钮图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 文字字体
        //self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return self;
}

#pragma mark - 调整按钮内部 imageView 的 frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat newX = 0;
    CGFloat newY = 4;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height * scale - newY;
    return CGRectMake(newX, newY, newWidth, newHeight);
}

#pragma mark - 调整按钮内部 label 的 frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat newX = 0;
    CGFloat newY = contentRect.size.height * scale;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height - contentRect.size.height * scale - 3;
    return CGRectMake(newX, newY, newWidth, newHeight);
}

#pragma mark - 覆盖按钮的高亮方法（去掉按钮的高亮效果）
// 重写该方法可以去除长按按钮时出现的高亮效果
- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
