//
//  BRMortgageHelper.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRMortgageHelper.h"
#import "BRInputModel.h"
#import "BRResultModel.h"

@implementation BRMortgageHelper
// 按揭成数要除以10 (即值的范围：0.0~1.0)
// 利率要除以100 (即值的范围：0.0~1.0)

/** =================================== 商业贷款 =================================== */
#pragma mark - 商业贷款
#pragma mark 按商业贷款等额本息总价计算(总价)
+ (BRResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按商业贷款等额本息总价计算(总价)");
    // 贷款总额
    CGFloat loanTotalPrice = calcModel.businessTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    CGFloat monthRate = calcModel.bankRate / 100.0 / 12.0;
    // 每月还款
    CGFloat avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    CGFloat repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    CGFloat interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按商业贷款等额本金总价计算(总价)
+ (BRResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按商业贷款等额本金总价计算(总价)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款总额
    CGFloat loanTotalPrice = calcModel.businessTotalPrice;
    // 月利率
    CGFloat monthRate = calcModel.bankRate / 100.0 / 12.0;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    CGFloat avgMonthPrincipalRepayment = loanTotalPrice / loanMonthCount;
    // 还款总额
    CGFloat repayTotalPrice = 0;
    for (int i = 0; i < loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (贷款总额-每月还款*i) * 月利率
        CGFloat monthRepayment = avgMonthPrincipalRepayment + (loanTotalPrice - avgMonthPrincipalRepayment * i) * monthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    CGFloat interestPayment = repayTotalPrice - calcModel.businessTotalPrice;
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.firstMonthRepayment      = avgMonthPrincipalRepayment;
    return resultModel;
}
#pragma mark 按商业贷款等额本息单价计算(单价和面积)
+ (BRResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按商业贷款等额本息单价计算(单价和面积)");
    // 房屋总价
    CGFloat houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    CGFloat loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 首月还款
    CGFloat firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    CGFloat monthRate = calcModel.bankRate / 100.0 / 12.0;
    // 每月还款
    CGFloat avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    CGFloat repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    CGFloat interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按商业贷款等额本金单价计算(单价和面积)
+ (BRResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按商业贷款等额本金单价计算(单价和面积)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    CGFloat avgMonthPrincipalRepayment = calcModel.unitPrice * calcModel.area * calcModel
    .mortgageMulti / 10.0 / loanMonthCount;
    // 房屋总价
    CGFloat houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    CGFloat loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 还款总额
    CGFloat repayTotalPrice = 0;
    for (int i = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (单价*面积*按揭成数-每月还款*i) * 月利率
        CGFloat monthRepayment = avgMonthPrincipalRepayment
        +(calcModel.unitPrice * calcModel.area * calcModel.mortgageMulti / 10.0 - avgMonthPrincipalRepayment * i)
        *(calcModel.bankRate / 100 / 12.0);
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    CGFloat interestPayment = repayTotalPrice-loanTotalPrice;
    // 首月还款
    CGFloat firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    return resultModel;
}


/** =================================== 公积金贷款 =================================== */
#pragma mark - 公积金贷款
#pragma mark 按公积金贷款等额本息总价计算(总价)
+ (BRResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按公积金贷款等额本息总价计算(总价)");
    // 贷款总额
    CGFloat loanTotalPrice = calcModel.fundTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    CGFloat monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 每月还款
    CGFloat avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    CGFloat repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    CGFloat interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按公积金贷款等额本金总价计算(总价)
+ (BRResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按公积金贷款等额本金总价计算(总价)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款总额
    CGFloat loanTotalPrice = calcModel.fundTotalPrice;
    // 月利率
    CGFloat monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    CGFloat avgMonthPrincipalRepayment = loanTotalPrice / loanMonthCount;
    // 还款总额
    CGFloat repayTotalPrice = 0;
    for (int i  = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (贷款总额-每月还款*i) * 月利率
        CGFloat monthRepayment = avgMonthPrincipalRepayment + (loanTotalPrice - avgMonthPrincipalRepayment * i) * monthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    CGFloat interestPayment = repayTotalPrice - calcModel.fundTotalPrice;
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按公积金贷款等额本息单价计算(单价和面积)
+ (BRResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按公积金贷款等额本息单价计算(单价和面积)");
    // 房屋总价
    CGFloat houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    CGFloat loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 首月还款
    CGFloat firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 月利率
    CGFloat monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 每月还款
    CGFloat avgMonthRepayment = loanTotalPrice*monthRate*powf(1+monthRate, loanMonthCount)/(powf(1+monthRate, loanMonthCount)-1);
    // 还款总额
    CGFloat repayTotalPrice = avgMonthRepayment*loanMonthCount;
    // 支付利息
    CGFloat interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按公积金贷款等额本金单价计算(单价和面积)
+ (BRResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按公积金贷款等额本金单价计算(单价和面积)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 每月所还本金（每月还款）
    CGFloat avgMonthPrincipalRepayment = calcModel.unitPrice * calcModel.area * calcModel
    .mortgageMulti / 10.0 / loanMonthCount;
    // 房屋总价
    CGFloat houseTotalPrice = calcModel.unitPrice * calcModel.area;
    // 贷款总额
    CGFloat loanTotalPrice = houseTotalPrice * calcModel.mortgageMulti / 10.0;
    // 月利率
    CGFloat monthRate = calcModel.fundRate / 100.0 / 12.0;
    // 还款总额
    CGFloat repayTotalPrice = 0;
    for (int i = 0; i < loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (单价*面积*按揭成数-每月还款*i) * 月利率
        CGFloat monthRepayment = avgMonthPrincipalRepayment
        +(calcModel.unitPrice * calcModel.area * calcModel.mortgageMulti / 10.0 - avgMonthPrincipalRepayment * i) * monthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    CGFloat interestPayment = repayTotalPrice - loanTotalPrice;
    // 首月还款
    CGFloat firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.houseTotalPrice          = houseTotalPrice;
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = firstMonthRepayment;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}

/** =================================== 组合型贷款 =================================== */
#pragma mark - 组合型贷款
#pragma mark 按组合型贷款等额本息总价计算(总价)
+ (BRResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按组合型贷款等额本息总价计算(总价)");
    // 商业贷款
    CGFloat businessTotalPrice = calcModel.businessTotalPrice;
    // 公积金贷款
    CGFloat fundTotalPrice = calcModel.fundTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 银行月利率
    CGFloat bankMonthRate = calcModel.bankRate / 100.0 / 12.0;
    // 公积金月利率
    CGFloat fundMonthRate = calcModel.fundRate / 100.0 / 12.0;
    // 贷款总额
    CGFloat loanTotalPrice = businessTotalPrice + fundTotalPrice;
    // 每月还款
    CGFloat avgMonthRepayment = businessTotalPrice * bankMonthRate * powf(1 + bankMonthRate, loanMonthCount) / (powf(1 + bankMonthRate, loanMonthCount) - 1)
    +
    fundTotalPrice * fundMonthRate * powf(1 + fundMonthRate, loanMonthCount) / (powf(1 + fundMonthRate, loanMonthCount) - 1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment * loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice - loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
    }
    
    BRResultModel *resultModel = [BRResultModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = avgMonthRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}
#pragma mark 按组合型贷款等额本金总价计算(总价)
+ (BRResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel {
    NSLog(@"按组合型贷款等额本金总价计算(总价)");
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    // 商业贷款
    CGFloat businessTotalPrice = calcModel.businessTotalPrice;
    // 公积金贷款
    CGFloat fundTotalPrice = calcModel.fundTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = calcModel.mortgageYear * 12;
    // 银行月利率
    CGFloat bankMonthRate = calcModel.bankRate / 100.0 / 12.0;
    // 公积金月利率
    CGFloat fundMonthRate = calcModel.fundRate / 100.0 / 12.0;
    // 贷款总额
    CGFloat loanTotalPrice = businessTotalPrice + fundTotalPrice;
    // 商业每月所还本金（每月还款）
    CGFloat businessAvgMonthPrincipalRepayment = businessTotalPrice / loanMonthCount;
    // 公积金每月所还本金（每月还款）
    CGFloat fundAvgMonthPrincipalRepayment = fundTotalPrice / loanMonthCount;
    // 还款总额
    CGFloat repayTotalPrice = 0;
    for (int i = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (贷款总额-每月还款*i) * 月利率
        CGFloat monthRepayment = businessAvgMonthPrincipalRepayment + (businessTotalPrice - businessAvgMonthPrincipalRepayment * i) * bankMonthRate + fundAvgMonthPrincipalRepayment + (fundTotalPrice - fundAvgMonthPrincipalRepayment * i) * fundMonthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice += monthRepayment;
    }
    // 支付利息
    CGFloat interestPayment = repayTotalPrice - loanTotalPrice;
    
    BRResultModel *resultModel = [[BRResultModel alloc]init];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.repayTotalPrice          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.mortgageYear             = calcModel.mortgageYear;
    resultModel.mortgageMonth            = loanMonthCount;
    resultModel.avgMonthRepayment        = businessAvgMonthPrincipalRepayment + fundAvgMonthPrincipalRepayment;
    resultModel.firstMonthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.monthRepaymentArr        = monthRepaymentArr;
    return resultModel;
}

@end