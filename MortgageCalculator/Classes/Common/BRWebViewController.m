//
//  BRWebViewController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRWebViewController.h"
#import <WebKit/WebKit.h>

@interface BRWebViewController ()<WKNavigationDelegate>
// 导航栏背景
@property (nonatomic, strong) UIImageView *navImageView;
// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
// 关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
// webView
@property (nonatomic, strong) WKWebView *webView;
// 加载进度条
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation BRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initUI];
    [self loadData];
}

- (void)initUI {
    // webView
    [self.view addSubview:self.webView];
    [self.view addSubview:self.navImageView];
    [self.view addSubview:self.progressView];
    // 返回按钮
    self.backBtn.hidden = NO;
}

// 加载URL
- (void)loadData {
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - WKNavigationDelegate
/** 页面开始加载时调用 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    NSLog(@"当前页面的title：%@", webView.title); // 当前页面的title
}

// 内容加载失败时候调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"页面加载超时");
    [MBProgressHUD showError:@"网络不给力"];
}

#pragma mark - WKNavigationDelegate - 拦截URL
// 用户点击网页上的链接，需要打开新页面时，将先调用这个方法
// 服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *currentURL = URL.absoluteString;
    NSLog(@"拦截URL：%@", currentURL);
    if ([currentURL containsString:@"xxxx###.html"]) {
        decisionHandler(WKNavigationActionPolicyCancel); //取消加载
        // 关闭webView，回到原生页面
        [self closeNative];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow); //允许加载
    }
}

- (UIImageView *)navImageView {
    if (!_navImageView) {
        _navImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
        _navImageView.image = [UIImage imageNamed:@"navbar_bg"];
    }
    return _navImageView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _webView.backgroundColor = [UIColor clearColor];
        // 允许左右滑动手势返回
        //_webView.allowsBackForwardNavigationGestures = YES;
        // 1. 添加 KVO 观察者（观察进度）
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
        _webView.navigationDelegate = self;
        
    }
    return _webView;
}

// 2. 实现代理方法。KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        self.progressView.hidden = NO;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [self.progressView setProgress:1.0f animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView setProgress:0.0f animated:NO];
                self.progressView.hidden = YES;
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 1);
        _progressView.trackTintColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
        // 设置进度条颜色
        _progressView.tintColor = [UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000];
    }
    return _progressView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.backgroundColor = [UIColor clearColor];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navbar_return"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navbar_return"] forState:UIControlStateHighlighted];
        [_backBtn sizeToFit]; // 图片自动适应按钮大小
        [_backBtn addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(self.view.mas_top).with.offset(42);
            make.size.mas_equalTo(CGSizeMake(60, 40));
        }];
    }
    return _backBtn;
}

//点击返回的方法
- (void)clickBackButton {
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.backBtn.hidden = NO;
        self.closeBtn.hidden = NO;
    } else {
        [self closeNative];
    }
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn sizeToFit]; // 图片自动适应按钮大小
        _closeBtn.hidden = YES;
        [_closeBtn addTarget:self action:@selector(closeNative) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backBtn.mas_right).with.offset(5);
            make.centerY.mas_equalTo(self.view.mas_top).with.offset(42);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            
        }];
    }
    return _closeBtn;
}

//关闭H5页面，直接回到原生页面
- (void)closeNative {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    // 3. 移除观察者
    [_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    _webView.navigationDelegate = nil;
}

@end
