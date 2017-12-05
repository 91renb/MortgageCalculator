//
//  BRFeedbackViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRFeedbackViewController.h"
#import "BRTextView.h"
#import "BRUserHelper.h"

@interface BRFeedbackViewController ()<UITextViewDelegate>
@property (nonatomic, strong) BRTextView *textView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation BRFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"意见反馈", nil);
    self.textView.hidden = NO;
    self.sendButton.hidden = NO;
}

- (void)saveData {
    if ([self.textView.text isEqualToString:@"#开启#"]) {
        [BRUserHelper setMySwitch:YES];
    }
    NSLog(@"请求成功！");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BRTextView *)textView {
    if (_textView == nil) {
        _textView = [[BRTextView alloc]initWithFrame:CGRectMake(10 * kScaleFit, 10 * kScaleFit, VIEW_WIDTH - 20 * kScaleFit, 120 * kScaleFit)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = RGB(227, 224, 216, 1.0f).CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.delegate = self;
        _textView.placeholderColor = RGB_HEX(0x898989, 1.0f);
        _textView.placeholder = NSLocalizedString(@"请输入意见和反馈", nil);
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 3.0f * kScaleFit;
        _sendButton.frame = CGRectMake(30 * kScaleFit, self.textView.frame.origin.y + self.textView.frame.size.height + 30 * kScaleFit, VIEW_WIDTH - 60 * kScaleFit, 44 * kScaleFit);
        _sendButton.backgroundColor = kThemeColor;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
        [_sendButton setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendButton];
    }
    return _sendButton;
}

- (void)clickSendButton {
    NSLog(@"点击了提交");
    if (self.textView.text != nil && self.textView.text.length > 0) {
        [self saveData];
    } else {
        [MBProgressHUD showMessage:NSLocalizedString(@"请输入意见和反馈", nil)];
    }
}

#pragma mark -- 按回车键退出键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
