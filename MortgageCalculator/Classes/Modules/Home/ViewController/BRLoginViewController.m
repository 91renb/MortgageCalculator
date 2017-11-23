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
        CURRENT_THREAD
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
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 10 - 10, kkRowHeight * 2)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.borderWidth = 0.4;
    backView.layer.borderColor = RGB_HEX(0xe0e0e0, 1.0f).CGColor;
    [self.view addSubview:backView];
    
    //手机图标
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kkRowHeight, kkRowHeight)];
    phoneImageView.backgroundColor = [UIColor clearColor];
    phoneImageView.contentMode = UIViewContentModeCenter;
    phoneImageView.image = [UIImage imageNamed:@"dl_nmb"];
    [backView addSubview:phoneImageView];
    
    //手机号TextField
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 10 - 10, kkRowHeight)];
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
    [backView addSubview:phoneTF];
    self.phoneTF = phoneTF;
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kkRowHeight, SCREEN_WIDTH - 10 - 10, 0.5)];
    lineView.backgroundColor = RGB_HEX(0xe0e0e0, 1.0f);
    [backView addSubview:lineView];
    
    //创建密码视图
    UIImageView *pwdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kkRowHeight, kkRowHeight)];
    pwdImageView.backgroundColor = [UIColor clearColor];
    pwdImageView.contentMode = UIViewContentModeCenter;
    pwdImageView.image = [UIImage imageNamed:@"dl_Lock"];
    [backView addSubview:pwdImageView];
    
    //密码TextField
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(0, kkRowHeight, SCREEN_WIDTH - 10 - 10, kkRowHeight)];
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
    [backView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //记住密码按钮
    UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberBtn.frame = CGRectMake(backView.frame.origin.x, backView.bottom+7, 90, 30);
    [rememberBtn setTitle:@"  记住密码" forState:UIControlStateNormal];
    [rememberBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    rememberBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rememberBtn setImage:[UIImage imageNamed:@"dl_kuang.png"] forState:UIControlStateNormal];
    [rememberBtn setImage:[UIImage imageNamed:@"dl_kuang1.png"] forState:UIControlStateSelected];
    [rememberBtn addTarget:self action:@selector(clickRememberPwd:) forControlEvents:UIControlEventTouchUpInside];
    rememberBtn.selected = [BRUserHelper pwd].length > 0 ? YES : NO;
    isRememberPwd = rememberBtn.isSelected;
    [self.view addSubview:rememberBtn];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(backView.origin.x, backView.bottom + 80, backView.frame.size.width, 40);
    loginBtn.backgroundColor = [UIColor colorWithRed:180/255.0 green:45/255.0  blue:25/255.0 alpha:0.8];
    loginBtn.layer.cornerRadius = 2;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:loginBtn];
    
    // 注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(loginBtn.origin.x, loginBtn.bottom + 10, loginBtn.frame.size.width, loginBtn.frame.size.height);
    registerBtn.backgroundColor = [UIColor whiteColor];
    registerBtn.layer.borderColor = RGB_HEX(0xe0e0e0, 1.0f).CGColor;
    registerBtn.layer.borderWidth = 0.5;
    registerBtn.layer.cornerRadius = 2;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:registerBtn];
    
    // 忘记密码按钮
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetBtn.frame = CGRectMake(registerBtn.origin.x, registerBtn.bottom+10, registerBtn.frame.size.width, 30);
    forgetBtn.layer.cornerRadius = 0;
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickResetPwd) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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
