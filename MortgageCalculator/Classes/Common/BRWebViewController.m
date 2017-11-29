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
    [self setupNav];
    // webView
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
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

#pragma mark - 设置导航栏
- (void)setupNav {
    // 设置导航栏背景图片
    UIImageView *navImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, NAV_HEIGHT)];
    navImageView.backgroundColor = kNavBarColor;
    //navImageView.image = [UIImage imageNamed:@""];
    [self.view addSubview:navImageView];
    self.navImageView = navImageView;
    // 设置分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGB_HEX(0XE3E3E3, 1.0);
    [navImageView addSubview:lineView];
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f * kScaleFit];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUSBAR_HEIGHT);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navbar_return"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"navbar_return"] forState:UIControlStateHighlighted];
    //backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    //[backBtn sizeToFit]; // 图片自动适应按钮大小
    [backBtn addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUSBAR_HEIGHT + 2);
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    self.backBtn = backBtn;
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn sizeToFit]; // 图片自动适应按钮大小
    closeBtn.hidden = YES;
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUSBAR_HEIGHT + 2);
        make.left.mas_equalTo(backBtn.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.closeBtn = closeBtn;
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
        [self clickCloseBtn];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow); //允许加载
    }
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
        _progressView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 1);
        _progressView.trackTintColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
        // 设置进度条颜色
        _progressView.tintColor = [UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000];
    }
    return _progressView;
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
        [self clickCloseBtn];
    }
}

//关闭H5页面，直接回到原生页面
- (void)clickCloseBtn {
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
