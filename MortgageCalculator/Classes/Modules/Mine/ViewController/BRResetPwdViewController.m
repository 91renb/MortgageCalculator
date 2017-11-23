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
    self.navigationItem.title = @"重置密码";
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
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 10 - 10, kkRowHeight * 3)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.borderWidth = 0.4;
    backView.layer.borderColor = RGB_HEX(0xe0e0e0, 1.0f).CGColor;
    [self.view addSubview:backView];
    
    //1.手机号
    UILabel *phoneLabel = [self getLabelWithOriginY:0 andText:@"手机号码："];
    [backView addSubview:phoneLabel];
    
    UITextField *phoneTF = [self getTextFieldWithPlaceholder:@"请输入手机号码"];
    phoneTF.frame = CGRectMake(100, 0, backView.width - 10 - 100, kkRowHeight);
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [backView addSubview:phoneTF];
    phoneTF.text = [BRUserHelper username];
    self.phoneTF = phoneTF;
    
    //分割线
    [backView addSubview:[self getLineViewWithOriginY:kkRowHeight]];
    
    //2.登录密码
    UILabel *pwdLabel = [self getLabelWithOriginY:kkRowHeight andText:@"新密码："];
    [backView addSubview:pwdLabel];
    
    UITextField *pwdTF = [self getTextFieldWithPlaceholder:@"请输入6~16位字符"];
    pwdTF.frame = CGRectMake(100, kkRowHeight, backView.width - 10 - 100, kkRowHeight);
    pwdTF.keyboardType = UIKeyboardTypeDefault;
    pwdTF.secureTextEntry = YES;
    [backView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //分割线
    [backView addSubview:[self getLineViewWithOriginY:kkRowHeight * 2]];
    
    //3.确认密码
    UILabel *pwd2Label = [self getLabelWithOriginY:kkRowHeight * 2 andText:@"确认密码："];
    [backView addSubview:pwd2Label];
    
    UITextField *pwd2TF = [self getTextFieldWithPlaceholder:@"请输入6~16位字符"];
    pwd2TF.frame = CGRectMake(100, kkRowHeight * 2, backView.width - 10 - 100, kkRowHeight);
    pwd2TF.keyboardType = UIKeyboardTypeDefault;
    pwd2TF.secureTextEntry = YES;
    [backView addSubview:pwd2TF];
    self.pwd2TF = pwd2TF;
    
    // 确定按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(backView.origin.x, backView.bottom + 50, backView.frame.size.width, 40);
    sureBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:45/255.0  blue:25/255.0 alpha:0.8];
    sureBtn.layer.cornerRadius = 2;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:sureBtn];
    
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH - 10 - 10, 0.5)];
    view.backgroundColor = RGB_HEX(0xe0e0e0, 1.0f);
    return view;
}


#pragma mark - 注册按钮点击事件
- (void)clickSureBtn {
    if ([NSString isBlankString:self.phoneTF.text]) {
        [MBProgressHUD showWarn:@"请输入手机号"];
        return;
    }
    if (![self.phoneTF.text checkTelNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if ([NSString isBlankString:self.pwdTF.text]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if (![self.pwd2TF.text isEqualToString:self.pwdTF.text]) {
        [MBProgressHUD showError:@"密码不一致"];
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
