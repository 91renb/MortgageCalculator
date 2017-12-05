//
//  BRResetPwdViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/25.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRResetPwdViewController.h"
#import "NSString+BRAdd.h"
#import "BRUserHelper.h"
#import <BmobSDK/BmobUser.h>
#import <UIView+YYAdd.h>

#define kkRowHeight 50

@interface BRResetPwdViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *pwd2TF;

@end

@implementation BRResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"重置密码", nil);
    [self initUI];
}

#pragma mark - 重置密码
- (void)requestDataForResetPwd {
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.msgCode andNewPassword:self.pwdTF.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"重置密码成功！");
            [BRUserHelper setUsername:@""];
            [BRUserHelper setPwd:@""];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"重置密码失败！");
        }
    }];
}

#pragma mark - 设置UI
- (void)initUI {
    //白色背景视图
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, VIEW_WIDTH - 10 - 10, kkRowHeight * 3)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    whiteView.layer.cornerRadius = 3.0f * kScaleFit;
    whiteView.layer.borderWidth = 0.4;
    whiteView.layer.borderColor = RGB_HEX(0xe0e0e0, 1.0f).CGColor;
    [self.view addSubview:whiteView];
    
    //1.手机号
    UILabel *phoneLabel = [self getLabelWithOriginY:0 andText:NSLocalizedString(@"手机号码：", nil)];
    [whiteView addSubview:phoneLabel];
    
    UITextField *phoneTF = [self getTextFieldWithPlaceholder:NSLocalizedString(@"请输入手机号", nil)];
    phoneTF.frame = CGRectMake(130, 0, whiteView.width - 10 - 130, kkRowHeight);
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [whiteView addSubview:phoneTF];
    phoneTF.text = [BRUserHelper username];
    self.phoneTF = phoneTF;
    
    //分割线
    [whiteView addSubview:[self getLineViewWithOriginY:kkRowHeight]];
    
    //2.登录密码
    UILabel *pwdLabel = [self getLabelWithOriginY:kkRowHeight andText:NSLocalizedString(@"新密码：", nil)];
    [whiteView addSubview:pwdLabel];
    
    UITextField *pwdTF = [self getTextFieldWithPlaceholder:NSLocalizedString(@"请输入6~16位字符", nil)];
    pwdTF.frame = CGRectMake(130, kkRowHeight, whiteView.width - 10 - 130, kkRowHeight);
    pwdTF.keyboardType = UIKeyboardTypeDefault;
    pwdTF.secureTextEntry = YES;
    [whiteView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //分割线
    [whiteView addSubview:[self getLineViewWithOriginY:kkRowHeight * 2]];
    
    //3.确认密码
    UILabel *pwd2Label = [self getLabelWithOriginY:kkRowHeight * 2 andText:NSLocalizedString(@"新密码：", nil)];
    [whiteView addSubview:pwd2Label];
    
    UITextField *pwd2TF = [self getTextFieldWithPlaceholder:NSLocalizedString(@"请输入6~16位字符", nil)];
    pwd2TF.frame = CGRectMake(130, kkRowHeight * 2, whiteView.width - 10 - 130, kkRowHeight);
    pwd2TF.keyboardType = UIKeyboardTypeDefault;
    pwd2TF.secureTextEntry = YES;
    [whiteView addSubview:pwd2TF];
    self.pwd2TF = pwd2TF;
    
    // 确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(20 * kScaleFit, whiteView.bottom + 40 * kScaleFit, VIEW_WIDTH - 40 * kScaleFit, 44 * kScaleFit);
    sureBtn.backgroundColor = kThemeColor;
    sureBtn.layer.cornerRadius = 3.0f * kScaleFit;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16 * kScaleFit];
    [sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}

- (UILabel *)getLabelWithOriginY:(CGFloat)originY andText:(NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, originY, 130, kkRowHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16 * kScaleFit];
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


#pragma mark - 注册按钮点击事件
- (void)clickSureBtn {
    if ([NSString isBlankString:self.phoneTF.text]) {
        [MBProgressHUD showWarn:NSLocalizedString(@"请输入手机号", nil)];
        return;
    }
    if (![self.phoneTF.text checkTelNumber]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入正确的手机号", nil)];
        return;
    }
    if ([NSString isBlankString:self.pwdTF.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入密码", nil)];
        return;
    }
    if (![self.pwd2TF.text isEqualToString:self.pwdTF.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"密码不一致", nil)];
        return;
    }
    
    // 注册请求
    [self requestDataForResetPwd];
}


#pragma mark - UITextField delegate
//TODO:开始输入
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.phoneTF) {
        if(self.phoneTF.text.length == 0) {
            self.pwdTF.text = @"";
        }
    }
    if (textField == self.pwdTF) {
        
    }
}

//TODO:输入限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *detailString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // 限制手机号长度
    if (textField == self.phoneTF) {
        if([detailString isEqualToString:@""]) {
            self.pwdTF.text = @"";
        }
        if (detailString.length > 11) {
            return NO;
        }
    }
    // 限制验证码长度
    if (textField == self.pwdTF) {
        if (detailString.length > 16) {
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
