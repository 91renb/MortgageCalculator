//
//  BRLoginViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRLoginViewController.h"
#import "BRRegisterViewController.h"
#import "BRForgetPwdViewController.h"
#import "BRUserHelper.h"
#import "NSString+BRAdd.h"
#import <BmobSDK/BmobUser.h>
#import <UIView+YYAdd.h>

#define kkRowHeight 50

@interface BRLoginViewController ()<UITextFieldDelegate>
{
    BOOL isRememberPwd;        //是否记住密码
}

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;
/** 登录按钮 */
@property (nonatomic, strong) UIButton *loginBtn;
/** 注册按钮 */
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation BRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BRUserHelper username].length > 0) {
        self.phoneTF.text = [BRUserHelper username];
    }
    if([BRUserHelper pwd].length > 0) {
        self.pwdTF.text = [BRUserHelper pwd];
    }
}

#pragma mark - 登录请求
- (void)requestDataForLogin {
    NSString *username = self.phoneTF.text;
    NSString *password = self.pwdTF.text;
    [BmobUser loginWithUsernameInBackground:username password:password block:^(BmobUser *user, NSError *error) {
        //登陆后返回的用户信息
        NSLog(@"登录请求：%@", user);
        if (user != nil) {
            [BRUserHelper setUsername:username];
            if (isRememberPwd) {
                [BRUserHelper setPwd:password];
            } else {
                [BRUserHelper setPwd:@""];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"登录失败：%@", error);
            [MBProgressHUD showError:@"用户名或密码错误"];
        }
    }];
}

#pragma mark - 绘制登陆界面
- (void)initUI {
    //白色背景视图
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, VIEW_WIDTH - 10 - 10, kkRowHeight * 2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 3.0f * kScaleFit;
    whiteView.layer.borderWidth = 0.4;
    whiteView.layer.borderColor = RGB_HEX(0xe0e0e0, 1.0f).CGColor;
    [self.view addSubview:whiteView];
    
    //手机图标
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (kkRowHeight - 20) / 2.0f, kkRowHeight, 20)];
    phoneImageView.backgroundColor = [UIColor clearColor];
    phoneImageView.contentMode = UIViewContentModeCenter;
    phoneImageView.image = [UIImage imageNamed:@"icon_phone"];
    
    //手机号TextField
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH - 10 - 10, kkRowHeight)];
    phoneTF.backgroundColor = [UIColor clearColor];
    phoneTF.placeholder = @"请输入手机号";
    phoneTF.font = [UIFont systemFontOfSize:16.0f];
    phoneTF.textColor = RGB(70, 70, 70, 1.0f);
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTF.borderStyle = UITextBorderStyleNone;
    phoneTF.leftView = phoneImageView;
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.delegate = self;
    [whiteView addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kkRowHeight, VIEW_WIDTH - 10 - 10, 0.5)];
    lineView.backgroundColor = RGB_HEX(0xe0e0e0, 1.0f);
    [whiteView addSubview:lineView];
    
    //创建密码视图
    UIImageView *pwdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (kkRowHeight - 24) / 2.0f, kkRowHeight, 22)];
    pwdImageView.backgroundColor = [UIColor clearColor];
    pwdImageView.contentMode = UIViewContentModeCenter;
    pwdImageView.image = [UIImage imageNamed:@"icon_pwd"];
    
    //密码TextField
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(0, kkRowHeight, VIEW_WIDTH - 10 - 10, kkRowHeight)];
    pwdTF.backgroundColor = [UIColor clearColor];
    pwdTF.placeholder = @"请输入密码";
    pwdTF.font = [UIFont systemFontOfSize:16.0f];
    pwdTF.textColor = RGB(70, 70, 70, 1.0f);
    pwdTF.secureTextEntry = YES;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.borderStyle = UITextBorderStyleNone;
    pwdTF.leftView = pwdImageView;
    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    pwdTF.delegate = self;
    [whiteView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //记住密码按钮
    UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.frame = CGRectMake(whiteView.frame.origin.x + 10, whiteView.bottom + 10, 90, 30);
    [rememberBtn setTitle:@"  记住密码" forState:UIControlStateNormal];
    [rememberBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    rememberBtn.titleLabel.font = [UIFont systemFontOfSize:15 * kScaleFit];
    [rememberBtn setImage:[UIImage imageNamed:@"icon_remember_nor"] forState:UIControlStateNormal];
    [rememberBtn setImage:[UIImage imageNamed:@"icon_remember_nor"] forState:UIControlStateHighlighted];
    [rememberBtn setImage:[UIImage imageNamed:@"icon_remember_sel"] forState:UIControlStateSelected];
    rememberBtn.contentMode = UIViewContentModeLeft;
    [rememberBtn addTarget:self action:@selector(clickRememberPwd:) forControlEvents:UIControlEventTouchUpInside];
    rememberBtn.selected = [BRUserHelper pwd].length > 0 ? YES : NO;
    isRememberPwd = rememberBtn.isSelected;
    [self.view addSubview:rememberBtn];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20 * kScaleFit, whiteView.bottom + 80, VIEW_WIDTH - 40 * kScaleFit, 44 * kScaleFit);
    loginBtn.backgroundColor = kThemeColor;
    loginBtn.layer.cornerRadius = 3.0f * kScaleFit;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16 * kScaleFit];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    // 注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(loginBtn.origin.x, loginBtn.bottom + 10 * kScaleFit, loginBtn.frame.size.width, loginBtn.frame.size.height);
    registerBtn.backgroundColor = [UIColor whiteColor];
    registerBtn.layer.borderColor = RGB_HEX(0xe0e0e0, 1.0f).CGColor;
    registerBtn.layer.borderWidth = 0.5;
    registerBtn.layer.cornerRadius = 3.0f * kScaleFit;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:16 * kScaleFit];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    // 忘记密码按钮
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake((VIEW_WIDTH - 100 * kScaleFit) / 2.0f, registerBtn.bottom + 10, 100 * kScaleFit, 30 * kScaleFit);
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickResetPwd) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    [self.view addSubview:forgetBtn];
}

// 记住密码
- (void)clickRememberPwd:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    isRememberPwd = sender.isSelected;
}

//TODO:登录的响应方法
- (void)clickLoginBtn {
    [self.view endEditing:YES];
    if ([NSString isBlankString:self.phoneTF.text]) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    if (![self.phoneTF.text checkTelNumber]) {
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }
    if ([NSString isBlankString:self.pwdTF.text]) {
        [MBProgressHUD showError:@"请输入登录密码"];
        return;
    }
    // 登录请求
    [self requestDataForLogin];
}

// 注册
- (void)clickRegisterBtn {
    BRRegisterViewController *registerVC = [[BRRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 忘记密码
- (void)clickResetPwd {
    BRForgetPwdViewController *forgetPwdVC =[[BRForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
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

//TODO:限制文本输入长度
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
    // 限制密码长度
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
