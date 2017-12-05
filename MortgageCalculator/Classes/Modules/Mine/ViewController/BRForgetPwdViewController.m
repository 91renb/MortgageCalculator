//
//  BRForgetPwdViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/25.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRForgetPwdViewController.h"
#import "NSString+BRAdd.h"
#import "BRMineHandler.h"
#import "UIButton+CountDown.h"
#import "BRUserHelper.h"
#import "BRResetPwdViewController.h"
#import <UIView+YYAdd.h>
#import <BmobSDK/BmobSMS.h>

#define kkRowHeight 50

@interface BRForgetPwdViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;

@end

@implementation BRForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"忘记密码", nil);
    [self initUI];
}

#pragma mark - 发送短信验证码请求
- (void)requestDataOfSendMessageCode:(UIButton *)button {
    //请求验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneTF.text andTemplate:@"短信模板一" resultBlock:^(int number, NSError *error) {
        if (!error) {
            NSLog(@"请求验证码成功");
            // 开始60秒倒计时
            [button startWithTime:60 color:kThemeColor countDownColor:RGB_HEX(0xc6c6c6, 1.0f)];
        } else {
            NSLog(@"请求失败：%@", error);
        }
    }];
}

#pragma mark - 验证验证码请求
- (void)requestDataOfVerifySMSCode {
    // 验证验证码是否正确
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneTF.text andSMSCode:self.codeTF.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"验证验证码成功");
            // 验证跳过后，跳到下一步页面
            BRResetPwdViewController *resetPwdVC = [[BRResetPwdViewController alloc]init];
            resetPwdVC.msgCode = self.codeTF.text;
            [self.navigationController pushViewController:resetPwdVC animated:YES];
        } else {
            NSLog(@"验证码错误");
            [MBProgressHUD showError:NSLocalizedString(@"请输入正确的验证码", nil)];
        }
    }];
}

#pragma mark - 设置UI
- (void)initUI {
    //白色背景视图
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, VIEW_WIDTH - 10 - 10, kkRowHeight * 2)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    whiteView.layer.cornerRadius = 3.0f * kScaleFit;
    whiteView.layer.borderWidth = 0.4;
    whiteView.layer.borderColor = RGB_HEX(0xe0e0e0, 1.0f).CGColor;
    [self.view addSubview:whiteView];
    
    //1.手机号
    UILabel *phoneLabel = [self getLabelWithOriginY:0 andText:NSLocalizedString(@"手机号码：", nil)];
    [whiteView addSubview:phoneLabel];
    
    UITextField *phoneTF = [self getTextFieldWithPlaceholder:NSLocalizedString(@"请输入手机号", nil)];
    phoneTF.frame = CGRectMake(100, 0, whiteView.width - 10 - 100, kkRowHeight);
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [whiteView addSubview:phoneTF];
    phoneTF.text = [BRUserHelper username];
    self.phoneTF = phoneTF;
    
    //分割线
    [whiteView addSubview:[self getLineViewWithOriginY:kkRowHeight]];
    
    //2.验证码
    UILabel *codeLabel = [self getLabelWithOriginY:kkRowHeight andText:NSLocalizedString(@"验证码：", nil)];
    [whiteView addSubview:codeLabel];
    
    UITextField *codeTF = [self getTextFieldWithPlaceholder:NSLocalizedString(@"请输入验证码", nil)];
    codeTF.frame = CGRectMake(100, kkRowHeight, whiteView.width - 10 - 100 - 100, kkRowHeight);
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [whiteView addSubview:codeTF];
    self.codeTF = codeTF;
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(codeTF.right + 10, kkRowHeight + 10, 85, kkRowHeight - 20);
    codeBtn.layer.cornerRadius = 4;
    codeBtn.backgroundColor = kThemeColor;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f * kScaleFit];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(clickCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:codeBtn];
    
    //分割线
    [whiteView addSubview:[self getLineViewWithOriginY:kkRowHeight * 2]];
    
    // 下一步按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(20 * kScaleFit, whiteView.bottom + 40 * kScaleFit, VIEW_WIDTH - 40 * kScaleFit, 44 * kScaleFit);
    nextBtn.backgroundColor = kThemeColor;
    nextBtn.layer.cornerRadius = 3.0f * kScaleFit;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16 * kScaleFit];
    [nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

- (UILabel *)getLabelWithOriginY:(CGFloat)originY andText:(NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, originY, 100, kkRowHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = [UIColor darkGrayColor];
    label.text = text;
    return label;
}

- (UITextField *)getTextFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textColor = RGB(70, 70, 70, 1.0f);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleNone;
    textField.delegate = self;
    return textField;
}

- (UIView *)getLineViewWithOriginY:(CGFloat)y {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, VIEW_WIDTH - 10 - 10, 0.5)];
    view.backgroundColor = RGB_HEX(0xe0e0e0, 1.0f);
    return view;
}


#pragma mark - 验证码按钮点击事件
- (void)clickCodeBtn:(UIButton *)button {
    if ([NSString isBlankString:self.phoneTF.text]) {
        [MBProgressHUD showWarn:NSLocalizedString(@"请输入手机号", nil)];
        return;
    }
    if (![self.phoneTF.text checkTelNumber]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入正确的手机号", nil)];
        return;
    }
    // 发送手机验证码
    [self requestDataOfSendMessageCode:button];
}

#pragma mark - 下一步按钮点击事件
- (void)clickNextBtn {
    if ([NSString isBlankString:self.phoneTF.text]) {
        [MBProgressHUD showWarn:NSLocalizedString(@"请输入手机号", nil)];
        return;
    }
    if (![self.phoneTF.text checkTelNumber]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入正确的手机号", nil)];
        return;
    }
    if ([NSString isBlankString:self.codeTF.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入验证码", nil)];
        return;
    }
    // 验证验证码是否正确
    [self requestDataOfVerifySMSCode];
}


#pragma mark - UITextField delegate
//TODO:输入限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *detailString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 限制验证码长度
    if (textField == self.codeTF) {
        if (detailString.length > 6) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
