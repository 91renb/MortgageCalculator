//
//  BRNewsListCell.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRNewsListModel;
@interface BRNewsListCell : UITableViewCell
/** 数据 */
@property (nonatomic, strong) BRNewsListModel *model;

@end
