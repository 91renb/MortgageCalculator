//
//  UIButton+CountDown.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/25.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "UIButton+CountDown.h"

@implementation UIButton (CountDown)

- (void)startWithTime:(NSInteger)seconds color:(UIColor *)color countDownColor:(UIColor *)countDownColor {
    __weak typeof(self) weakSelf = self;
    // 倒计时时间
    __block NSInteger timeOut = seconds;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = color;
                [weakSelf setTitle:NSLocalizedString(@"重新发送", nil) forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeOut % 61; // 从60数到1
            NSString * timeStr = [NSString stringWithFormat:@"%02d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backgroundColor = countDownColor;
                [weakSelf setTitle:[NSString stringWithFormat:@"%@ s",timeStr] forState:UIControlStateNormal];
                weakSelf.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
