//
//  APIConfig.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

// 是否发布(0 测试环境  1 正式环境)
#define IS_PRODUCT 0

/** TODO:APP配置信息 */
#define JPushAppKey  @"61f6302fb0c2abaecfe0e53e"
// Bmob Application ID，SDK初始化必须用到此密钥
#define BmobAppID @"1f7a7cf9084e46948e1b51754229e912"
// 第三方判断接口
#define APP_ID @"cbapp105" // 测试1：cbapp105  测试2：c8app165
#define API_AppSetting @"http://appmgr.jwoquxoc.com/frontApi/getAboutUs" // 获取app的设置信息
/** appstore更新地址 */
#define APP_STORE_ID @"1320892879"
// 去下载地址
#define APP_STORE_URL [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@", APP_STORE_ID]
#define APP_STORE_URL2 [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APP_STORE_ID]
// 去评分地址
#define APP_STORE_COMMENT [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APP_STORE_ID]


/** TODO:服务器地址 */
#if IS_PRODUCT
/** ------------------发布状态------------------ */
#define SERVER_HOST @"http://client.lotunion.com"

#else
/** ------------------调试状态------------------ */
#define SERVER_HOST @"http://client.lotunion.com"

#endif

/** TODO:API基本地址 */
#define AppBaseUrl [NSString stringWithFormat:@"%@/api/xxx", SERVER_HOST]


/** TODO:URL详细地址 */

/** 获取短信验证码地址 */
#define PhoneMessageCodeUrl @"http://ibaby.junbaotech.cn/FSFY/disPatchJson?clazz=RMISERVICE&sUserID=null&key=SENDSMS&sExParams=http://apps.junbaotech.cn/FSFY/disPatchJson&sParams="


#endif /* APIConfig_h */
