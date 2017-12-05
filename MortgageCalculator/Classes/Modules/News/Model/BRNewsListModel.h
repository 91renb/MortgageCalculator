//
//  BRNewsListModel.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRNewsListModel : NSObject

@property (nonatomic, strong) NSString *docid;
@property (nonatomic, strong) NSString *title; // 新闻标题
@property (nonatomic, strong) NSArray *images; // 图片数组
@property (nonatomic, strong) NSString *date;  // 创建时间
@property (nonatomic, strong) NSString *url;   // 资讯详情url
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *source; // 资讯来源
@property (nonatomic, strong) NSString *ctype;
@property (nonatomic, strong) NSString *summary; // 摘要
@property (nonatomic, strong) NSString *media_pic;
@property (nonatomic, strong) NSString *media_name;

@end
