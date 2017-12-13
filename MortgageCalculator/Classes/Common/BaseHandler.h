//
//  BaseHandler.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 继承基类，子类就可以使用这些公共的block

/**
 *  处理完成事件
 */
typedef void(^CompleteBlock)(void);

/**
 *  处理事件成功
 *
 *  @param obj 返回数据
 */
typedef void(^SuccessBlock)(id obj);

/**
 *  处理事件失败
 *
 *  @param error 错误信息
 */
typedef void(^FailedBlock)(id error);

@interface BaseHandler : NSObject

@end
