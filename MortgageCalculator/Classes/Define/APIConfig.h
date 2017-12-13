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
#define IS_PRODUCT 1

/** TODO:APP配置信息 */
#define JPushAppKey  @"61f6302fb0c2abaecfe0e53e"
// Bmob Application ID，SDK初始化必须用到此密钥
#define BmobAppID @"1f7a7cf9084e46948e1b51754229e912"
/** appstore更新地址 */
#define APP_STORE_ID @"1320892879"
// 去下载地址
#define APP_STORE_URL [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@", APP_STORE_ID]
// 去评分地址
#define APP_STORE_COMMENT [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APP_STORE_ID]


/** TODO:服务器地址 */
#if IS_PRODUCT
/** ------------------发布状态------------------ */
#define SERVER_HOST @"#"

#else
/** ------------------调试状态------------------ */
#define SERVER_HOST @"#"

#endif

/** TODO:API基本地址 */
#define AppBaseUrl [NSString stringWithFormat:@"%@/api/xxx", SERVER_HOST]

#endif /* APIConfig_h */
