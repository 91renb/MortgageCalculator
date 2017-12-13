//
//  WapWebViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/12.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "WapWebViewController.h"

@interface WapWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WapWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBarHidden = YES;
    self.webView.hidden = NO;
    // iOS11适配
    if (@available(iOS 11.0, *)) {
        // 不计算内边距
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 调整UIScrollView显示内容的位置(iOS11已废弃该属性)
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)setWebUrl:(NSString *)webUrl {
    _webUrl = webUrl;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSLog(@"拦截URL:%@", url);
    if ([url hasPrefix:@"itms-appss://"]) {
        // 【强制更新功能】去AppStore更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showLoading:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"加载完成");
    if (self.webUrl.length > 0) {
        [MBProgressHUD hideHUD];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载失败");
    if (self.webUrl.length > 0) {
        [MBProgressHUD hideHUD];
    }
    // 加载失败，就重新加载
    //[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}

@end
