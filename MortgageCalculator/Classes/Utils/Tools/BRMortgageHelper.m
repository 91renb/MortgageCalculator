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
// 贷款金额要乘以10000 (万元——>元)
// 按揭成数要除以10 (即值的范围：0.0~1.0)
// 利率要除以100 (即值的范围：0.0~1.0)

/** =================================== 商业贷款 / 公积金贷款 =================================== */
#pragma mark - 商业贷款 / 公积金贷款
#pragma mark 等额本息（按总价计算）
+ (BRResultModel *)calculateLoanAsTotalPriceAndEqualPrincipalInterest:(BRInputModel *)inputModel {
    // 贷款总额
    NSInteger loanTotalPrice = inputModel.businessTotalPrice * 10000;
    // 贷款月数
    NSInteger loanMonthCount = inputModel.mortgageYear * 12;
    // 月利率 = 年利率 ÷ 12
    double monthRate = inputModel.bankRate / 100.0 / 12.0;
    // 每月月供额 =〔贷款本金 × 月利率 × (1＋月利率)＾还款月数〕÷〔(1＋月利率)＾还款月数-1〕
    double avgMonthRepayment = loanTotalPrice * monthRate * pow(1 + monthRate, loanMonthCount) / (pow(1 + monthRate, loanMonthCount) - 1);
    // 还款总额 = 每月月供额 * 贷款月数
    double repayTotalPrice = avgMonthRepayment * loanMonthCount;
    // 支付总利息 = 还款总额 - 贷款本金
    double interestPayment = repayTotalPrice - loanTotalPrice;
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < loanMonthCount; i++) {
        BRMonthResultModel *monthResultModel = [[BRMonthResultModel alloc]init];
        monthResultModel.number = [NSString stringWithFormat:@"%zi", i + 1];
        monthResultModel.monthRepayTotalPrice = [NSString stringWithFormat:@"%.2f", avgMonthRepayment];
        // 每月应还本金 = 贷款本金 × 月利率 × (1 + 月利率) ^ (还款月序号 - 1) ÷〔(1 + 月利率) ^ 还款月数 - 1〕
        double monthRepayPrice = loanTotalPrice * monthRate * pow(1 + monthRate, i + 1 - 1) / (pow(1 + monthRate, loanMonthCount) - 1);
        monthResultModel.monthRepayPrice = [NSString stringWithFormat:@"%.2f", monthRepayPrice];
        // 每月应还利息 = 贷款本金 × 月利率 ×〔(1 + 月利率) ^ 还款月数 - (1 + 月利率) ^ (还款月序号 - 1)〕÷〔(1 + 月利率) ^ 还款月数 - 1〕
        double monthRepayInterest = loanTotalPrice * monthRate * (pow(1 + monthRate, loanMonthCount) - pow(1 + monthRate, i + 1 - 1)) / (pow(1 + monthRate, loanMonthCount) - 1);
        monthResultModel.monthRepayInterest = [NSString stringWithFormat:@"%.2f", monthRepayInterest];
        [monthRepaymentArr addObject:monthResultModel];
    }
    
    BRResultModel *resultModel = [[BRResultModel alloc]init];
    // 贷款总额
    resultModel.loanTotalPrice = [NSString stringWithFormat:@"%zi", loanTotalPrice];
    // 首月还款（等额本息时，等于月均还款）
    //resultModel.firstMonthRepayment = [NSString stringWithFormat:@"%.2f", avgMonthRepayment];
    // 月均还款
    resultModel.avgMonthRepayment = [NSString stringWithFormat:@"%.2f", avgMonthRepayment];
    // 还款总利息
    resultModel.repayTotalInterest = [NSString stringWithFormat:@"%.2f", interestPayment];
    // 还款总额
    resultModel.repayTotalPrice = [NSString stringWithFormat:@"%.2f", repayTotalPrice];
    // 每月还款数组
    resultModel.monthRepaymentArr = monthRepaymentArr;
    
    return resultModel;
}

#pragma mark 等额本金（按总价计算）
+ (BRResultModel *)calculateLoanAsTotalPriceAndEqualPrincipal:(BRInputModel *)inputModel {
    // 贷款总额
    NSInteger loanTotalPrice = inputModel.businessTotalPrice * 10000;
    // 贷款月数
    NSInteger loanMonthCount = inputModel.mortgageYear * 12;
    // 月利率
    double monthRate = inputModel.bankRate / 100.0 / 12.0;
    // 每月应还本金 = 贷款本金 ÷ 还款月数
    double avgMonthPrincipalRepayment = loanTotalPrice / (loanMonthCount * 1.0);
    // 还款总额
    double repayTotalPrice = 0;
    // 每月还款模型数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < loanMonthCount; i++) {
        BRMonthResultModel *monthResultModel = [[BRMonthResultModel alloc]init];
        monthResultModel.number = [NSString stringWithFormat:@"%zi", i + 1];
        monthResultModel.monthRepayPrice = [NSString stringWithFormat:@"%.2f", avgMonthPrincipalRepayment];
        // 每月月供额 = 每月应还本金 + (贷款总额 - 每月应还本金 * i) * 月利率
        CGFloat monthRepayTotalPrice = avgMonthPrincipalRepayment + (loanTotalPrice - avgMonthPrincipalRepayment * i) * monthRate;
        monthResultModel.monthRepayTotalPrice = [NSString stringWithFormat:@"%.2f", monthRepayTotalPrice];
        // 每月应还利息 = 剩余本金 × 月利率 = (贷款总额 - 每月应还本金 * i) × 月利率
        CGFloat monthRepayInterest = (loanTotalPrice - avgMonthPrincipalRepayment * i) * monthRate;
        monthResultModel.monthRepayInterest = [NSString stringWithFormat:@"%.2f", monthRepayInterest];
        
        [monthRepaymentArr addObject:monthResultModel];
        // 累加每月月供额
        repayTotalPrice += monthRepayTotalPrice;
    }
    // 还款总利息 = 还款总额 - 贷款总额
    double repayTotalInterest = repayTotalPrice - loanTotalPrice;
    
    BRResultModel *resultModel = [[BRResultModel alloc]init];
    // 贷款总额
    resultModel.loanTotalPrice = [NSString stringWithFormat:@"%zi", loanTotalPrice];
    // 首月还款（等额本息时，等于月均还款）
    BRMonthResultModel *firstMonthResultModel = [monthRepaymentArr firstObject];
    resultModel.firstMonthRepayment = [NSString stringWithFormat:@"%@", firstMonthResultModel.monthRepayTotalPrice];
    // 还款总利息
    resultModel.repayTotalInterest = [NSString stringWithFormat:@"%.2f", repayTotalInterest];
    // 还款总额
    resultModel.repayTotalPrice = [NSString stringWithFormat:@"%.2f", repayTotalPrice];
    // 每月还款数组
    resultModel.monthRepaymentArr = monthRepaymentArr;
    return resultModel;
}

#pragma mark 等额本息（按单价和面积计算）
+ (BRResultModel *)calculateLoanAsUnitPriceAreaAndEqualPrincipalInterest:(BRInputModel *)inputModel {
    // 房屋总价 = 单价 * 面积
    double houseTotalPrice = inputModel.unitPrice * inputModel.area * 1.0;
    // 贷款总额
    double loanTotalPrice = houseTotalPrice * inputModel.mortgageMulti / 10.0;
    // 首期付款（首付）= 房屋总价 - 贷款总额
    double firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = inputModel.mortgageYear * 12;
    // 月利率
    double monthRate = inputModel.bankRate / 100.0 / 12.0;
    // 每月月供额 =〔贷款本金 × 月利率 × (1＋月利率)＾还款月数〕÷〔(1＋月利率)＾还款月数-1〕
    double avgMonthRepayment = loanTotalPrice * monthRate * pow(1 + monthRate, loanMonthCount) / (pow(1 + monthRate, loanMonthCount) - 1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment * loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice - loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        BRMonthResultModel *monthResultModel = [[BRMonthResultModel alloc]init];
        monthResultModel.number = [NSString stringWithFormat:@"%zi", i + 1];
        monthResultModel.monthRepayTotalPrice = [NSString stringWithFormat:@"%.2f", avgMonthRepayment];
        // 每月应还本金 = 贷款本金 × 月利率 × (1 + 月利率) ^ (还款月序号 - 1) ÷〔(1 + 月利率) ^ 还款月数 - 1〕
        double monthRepayPrice = loanTotalPrice * monthRate * pow(1 + monthRate, i + 1 - 1) / (pow(1 + monthRate, loanMonthCount) - 1);
        monthResultModel.monthRepayPrice = [NSString stringWithFormat:@"%.2f", monthRepayPrice];
        // 每月应还利息 = 贷款本金 × 月利率 ×〔(1 + 月利率) ^ 还款月数 - (1 + 月利率) ^ (还款月序号 - 1)〕÷〔(1 + 月利率) ^ 还款月数 - 1〕
        double monthRepayInterest = loanTotalPrice * monthRate * (pow(1 + monthRate, loanMonthCount) - pow(1 + monthRate, i + 1 - 1)) / (pow(1 + monthRate, loanMonthCount) - 1);
        monthResultModel.monthRepayInterest = [NSString stringWithFormat:@"%.2f", monthRepayInterest];
        [monthRepaymentArr addObject:monthResultModel];
    }
    
    BRResultModel *resultModel = [[BRResultModel alloc]init];
    // 贷款总额
    resultModel.loanTotalPrice = [NSString stringWithFormat:@"%.2f", loanTotalPrice];
    // 首期还款（首付）
    resultModel.firstMonthRepayment = [NSString stringWithFormat:@"%.2f", firstMonthRepayment];
    // 月均还款
    resultModel.avgMonthRepayment = [NSString stringWithFormat:@"%.2f", avgMonthRepayment];
    // 还款总利息
    resultModel.repayTotalInterest = [NSString stringWithFormat:@"%.2f", interestPayment];
    // 还款总额
    resultModel.repayTotalPrice = [NSString stringWithFormat:@"%.2f", repayTotalPrice];
    // 每月还款数组
    resultModel.monthRepaymentArr = monthRepaymentArr;
    
    return resultModel;
}

#pragma mark 等额本金（按单价和面积计算）
+ (BRResultModel *)calculateLoanAsUnitPriceAreaAndEqualPrincipal:(BRInputModel *)inputModel {
    // 房屋总价 = 单价 * 面积
    double houseTotalPrice = inputModel.unitPrice * inputModel.area * 1.0;
    // 贷款总额
    double loanTotalPrice = houseTotalPrice * inputModel.mortgageMulti / 10.0;
    // 首期付款（首付）= 房屋总价 - 贷款总额
    double firstMonthRepayment = houseTotalPrice - loanTotalPrice;
    // 贷款月数
    NSInteger loanMonthCount = inputModel.mortgageYear * 12;
    // 月利率
    double monthRate = inputModel.bankRate / 100.0 / 12.0;
    // 每月所还本金（每月还款本金）
    double avgMonthPrincipalRepayment = inputModel.unitPrice * inputModel.area * inputModel
    .mortgageMulti / 10.0 / (loanMonthCount * 1.0f);
    // 还款总额
    CGFloat repayTotalPrice = 0;
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<loanMonthCount; i++) {
        BRMonthResultModel *monthResultModel = [[BRMonthResultModel alloc]init];
        monthResultModel.number = [NSString stringWithFormat:@"%zi", i + 1];
        monthResultModel.monthRepayPrice = [NSString stringWithFormat:@"%.2f", avgMonthPrincipalRepayment];
        // 每月月供额 = 每月应还本金 + (贷款总额 - 每月应还本金 * i) * 月利率
        CGFloat monthRepayTotalPrice = avgMonthPrincipalRepayment + (loanTotalPrice - avgMonthPrincipalRepayment * i) * monthRate;
        monthResultModel.monthRepayTotalPrice = [NSString stringWithFormat:@"%.2f", monthRepayTotalPrice];
        // 每月应还利息 = 剩余本金 × 月利率 = (贷款总额 - 每月应还本金 * i) × 月利率
        CGFloat monthRepayInterest = (loanTotalPrice - avgMonthPrincipalRepayment * i) * monthRate;
        monthResultModel.monthRepayInterest = [NSString stringWithFormat:@"%.2f", monthRepayInterest];
        
        [monthRepaymentArr addObject:monthResultModel];
        // 累加每月月供额
        repayTotalPrice += monthRepayTotalPrice;
    }
    // 还款总利息 = 还款总额 - 贷款总额
    double repayTotalInterest = repayTotalPrice - loanTotalPrice;
    
    BRResultModel *resultModel = [[BRResultModel alloc]init];
    // 贷款总额
    resultModel.loanTotalPrice = [NSString stringWithFormat:@"%.2f", loanTotalPrice];
    // 首期付款（首付）
    resultModel.firstMonthRepayment = [NSString stringWithFormat:@"%.2f", firstMonthRepayment];
    // 还款总利息
    resultModel.repayTotalInterest = [NSString stringWithFormat:@"%.2f", repayTotalInterest];
    // 还款总额
    resultModel.repayTotalPrice = [NSString stringWithFormat:@"%.2f", repayTotalPrice];
    // 每月还款数组
    resultModel.monthRepaymentArr = monthRepaymentArr;
    
    return resultModel;
}

/** =================================== 组合型贷款 =================================== */
#pragma mark - 组合型贷款
#pragma mark 等额本息（按总价计算）
+ (BRResultModel *)calculateCombinedLoanAsEqualPrincipalInterest:(BRInputModel *)inputModel {
    // 商业贷款总额
    NSInteger businessTotalPrice = inputModel.businessTotalPrice * 10000;
    // 公积金贷款总额
    NSInteger fundTotalPrice = inputModel.fundTotalPrice * 10000;
    // 贷款月数
    NSInteger loanMonthCount = inputModel.mortgageYear * 12;
    // 贷款总额
    double loanTotalPrice = (businessTotalPrice + fundTotalPrice) * 1.0;
    // 银行月利率
    double bankMonthRate = inputModel.bankRate / 100.0 / 12.0;
    // 公积金月利率
    double fundMonthRate = inputModel.fundRate / 100.0 / 12.0;
    // 每月还款
    double avgMonthRepayment = businessTotalPrice * bankMonthRate * pow(1 + bankMonthRate, loanMonthCount) / (pow(1 + bankMonthRate, loanMonthCount) - 1) + fundTotalPrice * fundMonthRate * pow(1 + fundMonthRate, loanMonthCount) / (pow(1 + fundMonthRate, loanMonthCount) - 1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment * loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice - loanTotalPrice;
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < loanMonthCount; i++) {
        BRMonthResultModel *monthResultModel = [[BRMonthResultModel alloc]init];
        monthResultModel.number = [NSString stringWithFormat:@"%zi", i + 1];
        monthResultModel.monthRepayTotalPrice = [NSString stringWithFormat:@"%.2f", avgMonthRepayment];
        // 每月应还本金 = 贷款本金 × 月利率 × (1 + 月利率) ^ (还款月序号 - 1) ÷〔(1 + 月利率) ^ 还款月数 - 1〕
        double bankMonthRepayPrice = businessTotalPrice * bankMonthRate * pow(1 + bankMonthRate, i + 1 - 1) / (pow(1 + bankMonthRate, loanMonthCount) - 1);
        double fundMonthRepayPrice = fundTotalPrice * fundMonthRate * pow(1 + fundMonthRate, i + 1 - 1) / (pow(1 + fundMonthRate, loanMonthCount) - 1);
        double monthRepayPrice = bankMonthRepayPrice + fundMonthRepayPrice;
        monthResultModel.monthRepayPrice = [NSString stringWithFormat:@"%.2f", monthRepayPrice];
        // 每月应还利息 = 贷款本金 × 月利率 ×〔(1 + 月利率) ^ 还款月数 - (1 + 月利率) ^ (还款月序号 - 1)〕÷〔(1 + 月利率) ^ 还款月数 - 1〕
        double bankMonthRepayInterest = businessTotalPrice * bankMonthRate * (pow(1 + bankMonthRate, loanMonthCount) - pow(1 + bankMonthRate, i + 1 - 1)) / (pow(1 + bankMonthRate, loanMonthCount) - 1);
        double fundMonthRepayInterest = fundTotalPrice * fundMonthRate * (pow(1 + fundMonthRate, loanMonthCount) - pow(1 + fundMonthRate, i + 1 - 1)) / (pow(1 + fundMonthRate, loanMonthCount) - 1);
        double monthRepayInterest = bankMonthRepayInterest + fundMonthRepayInterest;
        monthResultModel.monthRepayInterest = [NSString stringWithFormat:@"%.2f", monthRepayInterest];
        [monthRepaymentArr addObject:monthResultModel];
    }
    BRResultModel *resultModel = [[BRResultModel alloc]init];
    // 贷款总额
    resultModel.loanTotalPrice = [NSString stringWithFormat:@"%.2f", loanTotalPrice];
    // 月均还款
    resultModel.avgMonthRepayment = [NSString stringWithFormat:@"%.2f", avgMonthRepayment];
    // 还款总利息
    resultModel.repayTotalInterest = [NSString stringWithFormat:@"%.2f", interestPayment];
    // 还款总额
    resultModel.repayTotalPrice = [NSString stringWithFormat:@"%.2f", repayTotalPrice];
    // 每月还款数组
    resultModel.monthRepaymentArr = monthRepaymentArr;
    return resultModel;
}

#pragma mark 等额本金（按总价计算）
+ (BRResultModel *)calculateCombinedLoanAsEqualPrincipal:(BRInputModel *)inputModel {
    // 商业贷款总额
    NSInteger businessTotalPrice = inputModel.businessTotalPrice * 10000;
    // 公积金贷款总额
    NSInteger fundTotalPrice = inputModel.fundTotalPrice * 10000;
    // 贷款总额
    double loanTotalPrice = (businessTotalPrice + fundTotalPrice) * 1.0;
    // 贷款月数
    NSInteger loanMonthCount = inputModel.mortgageYear * 12;
    // 银行月利率
    double bankMonthRate = inputModel.bankRate / 100.0 / 12.0;
    // 公积金月利率
    double fundMonthRate = inputModel.fundRate / 100.0 / 12.0;
    // 商业每月所还本金（每月还款）
    double businessAvgMonthPrincipalRepayment = businessTotalPrice / (loanMonthCount * 1.0);
    // 公积金每月所还本金（每月还款）
    double fundAvgMonthPrincipalRepayment = fundTotalPrice / (loanMonthCount * 1.0);
    // 每月应还本金
    double avgMonthPrincipalRepayment = businessAvgMonthPrincipalRepayment + fundAvgMonthPrincipalRepayment;
    // 还款总额
    double repayTotalPrice = 0;
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < loanMonthCount; i++) {
        BRMonthResultModel *monthResultModel = [[BRMonthResultModel alloc]init];
        monthResultModel.number = [NSString stringWithFormat:@"%zi", i + 1];
        monthResultModel.monthRepayPrice = [NSString stringWithFormat:@"%.2f", avgMonthPrincipalRepayment];
        // 每月月供额 = 每月应还本金 + (贷款总额 - 每月应还本金 * i) * 月利率
        CGFloat bankMonthRepayTotalPrice = businessAvgMonthPrincipalRepayment + (businessTotalPrice - businessAvgMonthPrincipalRepayment * i) * bankMonthRate;
        CGFloat fundMonthRepayTotalPrice = fundAvgMonthPrincipalRepayment + (fundTotalPrice - fundAvgMonthPrincipalRepayment * i) * fundMonthRate;
        CGFloat monthRepayTotalPrice = bankMonthRepayTotalPrice + fundMonthRepayTotalPrice;
        monthResultModel.monthRepayTotalPrice = [NSString stringWithFormat:@"%.2f", monthRepayTotalPrice];
        // 每月应还利息 = 剩余本金 × 月利率 = (贷款总额 - 每月应还本金 * i) × 月利率
        CGFloat bankMonthRepayInterest = (businessTotalPrice - businessAvgMonthPrincipalRepayment * i) * bankMonthRate;
        CGFloat fundMonthRepayInterest = (fundTotalPrice - fundAvgMonthPrincipalRepayment * i) * fundMonthRate;
        CGFloat monthRepayInterest = bankMonthRepayInterest + fundMonthRepayInterest;
        monthResultModel.monthRepayInterest = [NSString stringWithFormat:@"%.2f", monthRepayInterest];
        
        [monthRepaymentArr addObject:monthResultModel];
        // 累加每月月供额
        repayTotalPrice += monthRepayTotalPrice;
    }
    // 还款总利息 = 还款总额 - 贷款总额
    double repayTotalInterest = repayTotalPrice - loanTotalPrice;
    
    BRResultModel *resultModel = [[BRResultModel alloc]init];
    // 贷款总额
    resultModel.loanTotalPrice = [NSString stringWithFormat:@"%.2f", loanTotalPrice];
    // 首月还款（等额本息时，等于月均还款）
    BRMonthResultModel *firstMonthResultModel = [monthRepaymentArr firstObject];
    resultModel.firstMonthRepayment = [NSString stringWithFormat:@"%@", firstMonthResultModel.monthRepayTotalPrice];
    // 还款总利息
    resultModel.repayTotalInterest = [NSString stringWithFormat:@"%.2f", repayTotalInterest];
    // 还款总额
    resultModel.repayTotalPrice = [NSString stringWithFormat:@"%.2f", repayTotalPrice];
    // 每月还款数组
    resultModel.monthRepaymentArr = monthRepaymentArr;
    
    return resultModel;
}

@end
