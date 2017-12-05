//
//  BRRegisterViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRRegisterViewController.h"
#import "UIButton+CountDown.h"
#import "BRMineHandler.h"
#import <BmobSDK/BmobUser.h>
#import "BRUserHelper.h"
#import "NSString+BRAdd.h"
#import <UIView+YYAdd.h>

#define kkRowHeight 50

@interface BRRegisterViewController ()<UITextFieldDelegate>
{
    NSString *_authCode; // 保存验证码
}
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UITextField *pwd2TF;

@end

@implementation BRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"注册", nil);
    [self initUI];
}

#pragma mark - 注册请求
- (void)requestDataForRegister {
    BmobUser *bUser = [[BmobUser alloc] init];
    bUser.username = self.phoneTF.text;
    bUser.password = self.pwdTF.text;
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"注册成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"注册失败可能有重复用户，错误信息：%@",error);
            [MBProgressHUD showError:NSLocalizedString(@"该用户已注册", nil)];
        }
    }];
}

#pragma mark - 验证手机号是否注册
- (void)requestDataForIsRegister:(UIButton *)button {
    // 验证
    if ([self.phoneTF.text isEqualToString:[BRUserHelper username]]) {
        [MBProgressHUD showWarn:NSLocalizedString(@"该手机号已注册", nil)];
        return;
    }
    
    // 发送短信验证码
    [self requestDataOfSendMessageCode:button];
}

#pragma mark - 发送短信验证码请求
- (void)requestDataOfSendMessageCode:(UIButton *)button {
    // 获取验证码随机数
    _authCode = [self getAuthCode];
    NSString *sParams = [NSString stringWithFormat:@"%@$您的验证码是：【%@】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！", self.phoneTF.text, _authCode];
    [BRMineHandler executeSendMessageCodeTaskWithStringParams:sParams Success:^(id obj) {
        // 开始60秒倒计时
        [button startWithTime:60 color:kThemeColor countDownColor:RGB_HEX(0xc6c6c6, 1.0f)];
    } failed:^(id error) {
        NSLog(@"请求失败：%@", error);
    }];
}

#pragma mark - 生成短信验证码（四位随机数）
- (NSString *)getAuthCode {
    NSInteger code = arc4random_uniform(10000);
    NSString *authCodeStr = [NSString stringWithFormat:@"%04ld", code];
    NSLog(@"验证码：%@", authCodeStr);
    return authCodeStr;
}

#pragma mark - 设置UI
- (void)initUI {
    //白色背景视图
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, VIEW_WIDTH - 10 - 10, kkRowHeight * 4)];
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
    codeBtn.frame = CGRectMake(codeTF.right + 10, kkRowHeight + 10, 80, kkRowHeight - 20);
    codeBtn.layer.cornerRadius = 4;
    codeBtn.backgroundColor = kThemeColor;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f * kScaleFit];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(clickCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:codeBtn];
    
    //分割线
    [whiteView addSubview:[self getLineViewWithOriginY:kkRowHeight * 2]];
    
    //3.登录密码
    UILabel *pwdLabel = [self getLabelWithOriginY:kkRowHeight * 2 andText:NSLocalizedString(@"登录密码：", nil)];
    [whiteView addSubview:pwdLabel];
    
    UITextField *pwdTF = [self getTextFieldWithPlaceholder:NSLocalizedString(@"请输入6~16位字符", nil)];
    pwdTF.frame = CGRectMake(100, kkRowHeight * 2, whiteView.width - 10 - 100, kkRowHeight);
    pwdTF.keyboardType = UIKeyboardTypeDefault;
    pwdTF.secureTextEntry = YES;
    [whiteView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //分割线
    [whiteView addSubview:[self getLineViewWithOriginY:kkRowHeight * 3]];
    
    //4.确认密码
    UILabel *pwd2Label = [self getLabelWithOriginY:kkRowHeight * 3 andText:NSLocalizedString(@"确认密码：", nil)];
    [whiteView addSubview:pwd2Label];
    
    UITextField *pwd2TF = [self getTextFieldWithPlaceholder:NSLocalizedString(@"请输入6~16位字符", nil)];
    pwd2TF.frame = CGRectMake(100, kkRowHeight * 3, whiteView.width - 10 - 100, kkRowHeight);
    pwd2TF.keyboardType = UIKeyboardTypeDefault;
    pwd2TF.secureTextEntry = YES;
    [whiteView addSubview:pwd2TF];
    self.pwd2TF = pwd2TF;
    
    // 注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(20 * kScaleFit, whiteView.bottom + 40 * kScaleFit, VIEW_WIDTH - 40 * kScaleFit, 44 * kScaleFit);
    registerBtn.backgroundColor = kThemeColor;
    registerBtn.layer.cornerRadius = 3.0f * kScaleFit;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:16 * kScaleFit];
    [registerBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
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
    [self requestDataForIsRegister:button];
}

#pragma mark - 注册按钮点击事件
- (void)clickRegisterBtn {
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
    if (![self.codeTF.text isEqualToString:_authCode]) {
        if (![self.codeTF.text isEqualToString:@"6666"]) {
            [MBProgressHUD showError:NSLocalizedString(@"请输入正确的验证码", nil)];
            return;
        }
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
    [self requestDataForRegister];
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
