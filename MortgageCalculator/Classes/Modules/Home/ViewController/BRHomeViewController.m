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
@property (nonatomic, strong) NSArray *titleData;

@end

@implementation BRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    [self initUI];
}

- (void)initUI {
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
}

- (WMPageController *)pageController {
    if (!_pageController) {
        _pageController = [[WMPageController alloc]init];
        _pageController.viewFrame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        _pageController.menuBGColor = [UIColor whiteColor];
        _pageController.titleSizeNormal = 15.0f * kScaleFit;
        _pageController.titleSizeSelected = 15.0f * kScaleFit;
        _pageController.titleColorNormal = RGB_HEX(0x999999, 1.0f);
        _pageController.titleColorSelected = kThemeColor;
        //_pageController.progressColor = kThemeColor;
        _pageController.menuViewStyle = WMMenuViewStyleLine;
        _pageController.menuItemWidth = SCREEN_WIDTH / self.titleData.count;
        _pageController.menuHeight = 40;
        _pageController.dataSource = self;
        _pageController.delegate = self;
    }
    return _pageController;
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
        _titleData = @[@"商业贷款", @"公积金贷款", @"组合贷款"];
    }
    return _titleData;
}

@end
