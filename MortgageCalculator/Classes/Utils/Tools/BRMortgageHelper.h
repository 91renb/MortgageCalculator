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
/** =================================== 商业贷款/公积金贷款 =================================== */
/** 等额本息（按总价计算） */
+ (BRResultModel *)calculateLoanAsTotalPriceAndEqualPrincipalInterest:(BRInputModel *)inputModel;
/** 等额本金（按总价计算）*/
+ (BRResultModel *)calculateLoanAsTotalPriceAndEqualPrincipal:(BRInputModel *)inputModel;
/** 等额本息（按单价和面积计算） */
+ (BRResultModel *)calculateLoanAsUnitPriceAreaAndEqualPrincipalInterest:(BRInputModel *)inputModel;
/** 等额本金（按单价和面积计算） */
+ (BRResultModel *)calculateLoanAsUnitPriceAreaAndEqualPrincipal:(BRInputModel *)inputModel;

/** =================================== 组合型贷款 =================================== */
/** 等额本息（按总价计算） */
+ (BRResultModel *)calculateCombinedLoanAsEqualPrincipalInterest:(BRInputModel *)inputModel;
/** 等额本金（按总价计算） */
+ (BRResultModel *)calculateCombinedLoanAsEqualPrincipal:(BRInputModel *)inputModel;

@end
