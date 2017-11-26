//
//  BRInputModel.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRInputModel : NSObject
/** 商业贷款总额 */
@property (nonatomic, assign) NSInteger businessTotalPrice;
/** 公积金贷款总额 */
@property (nonatomic, assign) NSInteger fundTotalPrice;
/** 单价 */
@property (nonatomic, assign) double unitPrice;
/** 面积 */
@property (nonatomic, assign) double area;
/** 按揭年数 */
@property (nonatomic, assign) NSInteger mortgageYear;
/** 按揭成数 */
@property (nonatomic, assign) NSInteger mortgageMulti;
/** 银行利率 */
@property (nonatomic, assign) double bankRate;
/** 公积金利率 */
@property (nonatomic, assign) double fundRate;

@end
