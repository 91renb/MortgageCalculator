//
//  APIConfig.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef APIConfig_h
#define APIConfig_h

/** TODO:APP配置信息 */
#define APP_ID @"c8app165" // 测试1：cbapp105  测试2：c8app165
#define JPushAppKey  @"25c723449a62fc1e813efa6e"
#define BmobAppKey @"fa7df0110db72351c1748cad874def8c"
#define API_AppSetting @"http://appmgr.jwoquxoc.com/frontApi/getAboutUs" // 获取app的设置信息

#define App_ReviewingStatus @"0"    // 送审状态
#define App_SuccessStatus @"1"      // 审核成功状态
#define App_MyStatus @"2"           // 自定义我的状态

/** TODO:服务器地址 */
#ifdef DEBUG
/** ------------------调试状态------------------ */
#define SERVER_HOST @"http://client.lotunion.com"

#else
/** ------------------发布状态------------------ */
#define SERVER_HOST @"http://client.lotunion.com"

#endif

/** TODO:API基本地址 */
#define AppBaseUrl [NSString stringWithFormat:@"%@/api/xxx", SERVER_HOST]

/** TODO:API新闻列表地址 */
#define API_News @"https://smapi.159cai.com/discovery/news/szc/index.json?cfrom=ios&channel=tzhongcp&version=1"

/** TODO:URL详细地址 */

/** 获取短信验证码地址 */
#define PhoneMessageCodeUrl @"http://test.holier.cn/FSFY/disPatchJson?clazz=RMISERVICE&sUserID=null&key=SENDSMS&sExParams=http://apps.junbaotech.cn/FSFY/disPatchJson&sParams="

// 开奖URL
#define URL_KaiJiang @"https://qs.888.qq.com/m_qq/mqq2.info.html?_wv=1&vb2ctag=4_2087_3_2581&nodownload=1&id=805#info=getIssueAll"

#endif /* APIConfig_h */
