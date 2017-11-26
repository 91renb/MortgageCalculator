//
//  BRCalculateResultViewController.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    BRRepaymentWayPriceInterestSame, // 等额本息
    BRRepaymentWayPriceSame // 等额本金
} BRRepaymentWay; // 还款方式

@class BRResultModel;
@interface BRCalculateResultViewController : BaseViewController
/** 还款方式 */
@property (nonatomic, assign) BRRepaymentWay repaymentWay;
/** 计算结果模型 */
@property (nonatomic, strong) BRResultModel *resultModel;

@end
