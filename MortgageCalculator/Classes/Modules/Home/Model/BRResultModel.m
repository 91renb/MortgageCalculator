//
//  BRResultModel.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRResultModel.h"

@implementation BRResultModel
- (NSString *)description {
    return [NSString stringWithFormat:@"贷款总额: %f \n 还款总额: %f \n 支付利息: %f \n 按揭年数: %f \n 月均还款: %f \n 首月还款: %f \n ", self.loanTotalPrice, self.repayTotalPrice, self.interestPayment, self.mortgageYear, self.avgMonthRepayment, self.firstMonthRepayment];
}

@end
