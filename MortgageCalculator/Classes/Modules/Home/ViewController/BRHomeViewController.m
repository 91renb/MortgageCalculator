//
//  BRHomeViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRHomeViewController.h"
#import <WMPageController.h>
#import "BRBusinessLoanViewController.h"
#import "BRFundLoanViewController.h"
#import "BRCombinedLoanViewController.h"

@interface BRHomeViewController ()<WMPageControllerDataSource, WMPageControllerDelegate>
@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSArray *titleData;

@end

@implementation BRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // NSLocalizedString(key, comment) 本质
    // NSlocalizeString 第一个参数是key,根据key去对应语言的文件中取对应的字符串，第二个参数将会转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。
    self.navigationItem.title = NSLocalizedString(@"首页", nil);
    [self initUI];
}

- (void)initUI {
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.view addSubview:self.lineView];
}

- (WMPageController *)pageController {
    if (!_pageController) {
        _pageController = [[WMPageController alloc]init];
        // 导航栏的不透明度translucent = NO，
        // 这里的TABBAR_HEIGHT是自定义的view，所以还要减去这个防遮挡视图。
        // 此时 self.view.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        _pageController.viewFrame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - TABBAR_HEIGHT);
        _pageController.menuBGColor = [UIColor whiteColor];
        _pageController.titleSizeNormal = 15.0f * kScaleFit;
        _pageController.titleSizeSelected = 16.0f * kScaleFit;
        _pageController.titleColorNormal = RGB_HEX(0x999999, 1.0f);
        _pageController.titleColorSelected = kThemeColor;
        _pageController.progressColor = kThemeColor;
        _pageController.menuViewStyle = WMMenuViewStyleTriangle;
        //_pageController.progressWidth = 6;
        _pageController.progressViewWidths = @[@(12 * kScaleFit), @(12 * kScaleFit), @(12 * kScaleFit)];
        _pageController.progressHeight = 6.0f * kScaleFit;
        //_pageController.menuItemWidth = VIEW_WIDTH / self.titleData.count;
        // 自动通过字符串计算 MenuItem 的宽度
        _pageController.automaticallyCalculatesItemWidths = YES;
        _pageController.itemMargin = 15 * kScaleFit;
        _pageController.menuHeight = 40 * kScaleFit;
        _pageController.dataSource = self;
        _pageController.delegate = self;
    }
    return _pageController;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40 * kScaleFit, VIEW_WIDTH, 1.5f * kScaleFit)];
        _lineView.backgroundColor = kThemeColor;
    }
    return _lineView;
}

#pragma mark - WMPageControllerDataSource, WMPageControllerDelegate
#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        BRBusinessLoanViewController *businessLoanVC = [[BRBusinessLoanViewController alloc]init];
        return businessLoanVC;
    } else if (index == 1) {
        BRFundLoanViewController *fundLoanVC = [[BRFundLoanViewController alloc]init];
        return fundLoanVC;
    } else {
        BRCombinedLoanViewController *combinedLoanVC = [[BRCombinedLoanViewController alloc]init];
        return combinedLoanVC;
    }
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleData[index];
}

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[NSLocalizedString(@"商业贷款", nil), NSLocalizedString(@"公积金贷款", nil), NSLocalizedString(@"组合贷款", nil)];
    }
    return _titleData;
}

@end
