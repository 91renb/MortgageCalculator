//
//  BRMortgageHelper.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRInputModel, BRResultModel;
@interface BRMortgageHelper : NSObject
/** =================================== 商业贷款 =================================== */

/** 按商业贷款等额本息总价计算(总价) */
+ (BRResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)inputModel;
/** 按商业贷款等额本金总价计算(总价) */
+ (BRResultModel *)calculateBusinessLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)inputModel;
/** 按商业贷款等额本息单价计算(单价和面积) */
+ (BRResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)inputModel;
/** 按商业贷款等额本金单价计算(单价和面积) */
+ (BRResultModel *)calculateBusinessLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)inputModel;

/** =================================== 公积金贷款 =================================== */

/** 按公积金贷款等额本息总价计算(总价) */
+ (BRResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel;
/** 按公积金贷款等额本金总价计算(总价) */
+ (BRResultModel *)calculateFundLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel;
/** 按公积金贷款等额本息单价计算(单价和面积) */
+ (BRResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel;
/** 按公积金贷款等额本金单价计算(单价和面积) */
+ (BRResultModel *)calculateFundLoanAsUnitPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel;

/** =================================== 组合型贷款 =================================== */
/** 按组合型贷款等额本息总价计算(总价) */
+ (BRResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(BRInputModel *)calcModel;
/** 按组合型贷款等额本金总价计算(总价) */
+ (BRResultModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(BRInputModel *)calcModel;

@end
