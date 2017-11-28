//
//  BRNewsHandler.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseHandler.h"

@interface BRNewsHandler : BaseHandler
/**
 *  请求新闻列表
 *
 *  @param pageOffset   偏移个数（下次加载从偏移多个位置开始加载）
 *  @param pageSize     每页大小（每次加载多少条数据）
 *  @param success      成功后的回调
 *  @param failed       失败后的回调
 *
 */
+ (void)executeNewsListTaskWithPageOffset:(NSInteger)pageOffset pageSize:(NSInteger)pageSize Success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
