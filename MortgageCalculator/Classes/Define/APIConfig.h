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
#define APP_ID @"c8app165" // 测试1：cbapp105  测试2：c8app165
#define JPushAppKey  @"25c723449a62fc1e813efa6e"
#define BmobAppKey @"fa7df0110db72351c1748cad874def8c"
#define API_AppSetting @"http://appmgr.jwoquxoc.com/frontApi/getAboutUs" // 获取app的设置信息

#define App_ReviewingStatus @"0"    // 送审状态
#define App_SuccessStatus @"1"      // 审核成功状态
#define App_MyStatus @"2"           // 自定义我的状态

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

/** TODO:API新闻列表地址 */
// 分页加载：offset=0&count=10 （每次上拉，offset加10）
#define API_NewsList @"http://o.go2yd.com/open-api/caijing/channel?appid=x01Gjdp0kvyAVA6SZn7DGAt9&secretkey=98bcc4fa979b2e818fd5dfd2d971258a793d56f2&channel_id=%E6%88%BF%E4%BA%A7"

//#define API_NewsList @"http://o.go2yd.com/open-api/caijing/channel?appid=x01Gjdp0kvyAVA6SZn7DGAt9&nonce=sfdyuiy62&timestamp=1511789418&secretkey=98bcc4fa979b2e818fd5dfd2d971258a793d56f2&channel_id=%E6%88%BF%E4%BA%A7&offset=0&count=10"


/** TODO:URL详细地址 */

/** 获取短信验证码地址 */
#define PhoneMessageCodeUrl @"http://ibaby.junbaotech.cn/FSFY/disPatchJson?clazz=RMISERVICE&sUserID=null&key=SENDSMS&sExParams=http://apps.junbaotech.cn/FSFY/disPatchJson&sParams="


#endif /* APIConfig_h */
