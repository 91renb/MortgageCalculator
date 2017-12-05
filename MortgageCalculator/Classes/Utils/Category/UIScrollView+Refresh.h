//
//  UIScrollView+Refresh.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@interface UIScrollView (Refresh)
/** 添加头部刷新 */
- (void)addHeaderRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock;
/** 添加自定义头部刷新 */
- (void)addGifHeaderRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock;
/** 开始头部刷新 */
- (void)beginHeaderRefresh;
/** 结束头部刷新 */
- (void)endHeaderRefresh;

/** 添加脚部刷新 */
- (void)addFooterRefresh:(MJRefreshComponentRefreshingBlock)refreshBlock;
/** 开始脚部刷新 */
- (void)beginFooterRefresh;
/** 结束脚部刷新 */
- (void)endFooterRefresh;
/** 结束脚部刷新，没有跟多数据 */
- (void)endFooterRefreshWithNoMoreData;
/** 消除没有更多数据的状态 */
- (void)resetNoMoreData;

@end
