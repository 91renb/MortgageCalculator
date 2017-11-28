//
//  UIScrollView+Refresh.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)
/** 添加头部刷新 */
- (void)addHeaderRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock {
    MJRefreshNormalHeader *customRef = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshBlock];
    // 隐藏时间
    customRef.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //customRef.stateLabel.hidden = YES;
    // 这里还可以自定义 lastUpdatedTimeLabel和stateLabel 的显示样式
    
    self.mj_header = customRef;
}

/** 添加自定义头部刷新 */
- (void)addGifHeaderRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock {
    MJRefreshGifHeader *customRef = [MJRefreshGifHeader headerWithRefreshingBlock:refreshBlock];
    // 1.设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [customRef setImages:idleImages forState:MJRefreshStateIdle];
    // 2.设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *pullingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [pullingImages addObject:image];
    }
    [customRef setImages:pullingImages forState:MJRefreshStatePulling];
    // 3.设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [customRef setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 隐藏刷新时间
    customRef.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏刷新状态
    customRef.stateLabel.hidden = YES;
    // 这里还可以自定义 lastUpdatedTimeLabel和stateLabel 的显示样式
    
    self.mj_header = customRef;
}

/** 开始头部刷新 */
- (void)beginHeaderRefresh {
    [self.mj_header beginRefreshing];
}
/** 结束头部刷新 */
- (void)endHeaderRefresh {
    [self.mj_header endRefreshing];
}

/** 添加脚部刷新 */
- (void)addFooterRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock {
    MJRefreshAutoNormalFooter *customRef = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshBlock];
    //customRef.lastUpdatedTimeLabel.hidden = NO;
    //customRef.stateLabel.hidden = NO;
    self.mj_footer = customRef;
    //self.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:refreshBlock];
}
/** 开始脚部刷新 */
- (void)beginFooterRefresh {
    [self.mj_footer beginRefreshing];
}
/** 结束脚部刷新 */
- (void)endFooterRefresh {
    [self.mj_footer endRefreshing];
}

/** 结束脚部刷新，没有跟多数据 */
- (void)endFooterRefreshWithNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

@end
