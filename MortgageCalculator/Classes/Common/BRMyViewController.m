//
//  BRMyViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/28.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRMyViewController.h"

@interface BRMyViewController ()
@property (nonatomic, strong) UITextView *textView;

@end

@implementation BRMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.textView.hidden = NO;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 80)];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:30];
        _textView.editable = NO;
        _textView.text = self.showText;
        [self.view addSubview:_textView];
    }
    return _textView;
}

@end
