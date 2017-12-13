//
//  UIImageView+BRAdd.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "UIImageView+BRAdd.h"
#import <UIImageView+YYWebImage.h>

@implementation UIImageView (BRAdd)
#pragma mark - 异步加载图片
- (void)br_setImageWithPath:(NSString *)path placeholder:(NSString *)imageName {
    [self setImageWithURL:[NSURL URLWithString:path] placeholder:[UIImage imageNamed:imageName] options:YYWebImageOptionShowNetworkActivity completion:nil];
}

#pragma mark - 异步加载图片，可以监听下载进度，成功或失败
- (void)br_setImageWithPath:(NSString *)path
                placeholder:(NSString *)imageName
                   progress:(DownloadImageProgressBlock)progress
                    success:(DownloadImageSuccessBlock)success
                     failed:(DownloadImageFailedBlock)failed {
    __weak typeof(self) weakSelf = self;
    [self setImageWithURL:[NSURL URLWithString:path] placeholder:[UIImage imageNamed:imageName] options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progress(receivedSize * 1.0 / expectedSize);
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            failed(error);
        } else {
            weakSelf.image = image;
            success(image);
        }
    }];
}

@end
