//
//  BRTextView.h
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRTextView : UITextView
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification * )notification;

@end
