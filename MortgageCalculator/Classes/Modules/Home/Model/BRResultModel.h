//
//  BRResultModel.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRResultModel : NSObject
/* 房屋总价 */
@property (nonatomic, assign) CGFloat houseTotalPrice;
/** 贷款总额 */
@property (nonatomic, assign) CGFloat loanTotalPrice;
/** 还款总额 */
@property (nonatomic, assign) CGFloat repayTotalPrice;
/** 支付利息 */
@property (nonatomic, assign) CGFloat interestPayment;
/** 按揭年数 */
@property (nonatomic, assign) CGFloat mortgageYear;
/** 按揭月数 */
@property (nonatomic, assign) CGFloat mortgageMonth;
/** 月均还款 */
@property (nonatomic, assign) CGFloat avgMonthRepayment;
/** 首月还款 */
@property (nonatomic, assign) CGFloat firstMonthRepayment;
/** 每月还款数组 */
@property (nonatomic, strong) NSMutableArray *monthRepaymentArr;

@end
