//
//  BRResultModel.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRResultModel : NSObject
/** 贷款总额 */
@property (nonatomic, strong) NSString *loanTotalPrice;
/** 首月还款（等额本息时，等于月均还款） */
@property (nonatomic, strong) NSString *firstMonthRepayment;
/** 月均还款 */
@property (nonatomic, strong) NSString *avgMonthRepayment;
/** 还款总利息 */
@property (nonatomic, strong) NSString *repayTotalInterest;
/** 还款总额 */
@property (nonatomic, strong) NSString *repayTotalPrice;

/** 每月还款数组 */
@property (nonatomic, strong) NSMutableArray *monthRepaymentArr;

@end

/// 月还款模型
@interface BRMonthResultModel : NSObject
/** 当前还款期数 */
@property (nonatomic, strong) NSString *number;
/** 月还款总额 */
@property (nonatomic, strong) NSString *monthRepayTotalPrice;
/** 月还款本金 */
@property (nonatomic, strong) NSString *monthRepayPrice;
/** 月还款利息 */
@property (nonatomic, strong) NSString *monthRepayInterest;

@end

