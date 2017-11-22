//
//  NSObject+Parse.h
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Parse)
/** MJExtension 解析数组和字典需要使用不同的方法。我们自己合并,用代码判断 */
+ (id)parse:(id)responseObj;

@end
