//
//  BRMineHandler.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BaseHandler.h"

@interface BRMineHandler : BaseHandler

/**
 *  发送手机验证码
 *
 *  @param sParams  请求参数
 *  @param success  成功后的回调
 *  @param failed   失败后的回调
 *
 */
+ (void)executeSendMessageCodeTaskWithStringParams:(NSString *)sParams Success:(SuccessBlock)success failed:(FailedBlock)failed;

@end
