//
//  BRTabBarController.m
//  MyBaseProject
//
//  Created by 任波 on 2017/9/11.
//  Copyright © 2017年 任波. All rights reserved.
//

#import "BRTabBarController.h"
#import "BRTabBarButton.h"
#import "BRNavigationController.h"

#define NumMark_W_H 14   //数字角标直径
#define PointMark_W_H 8  //小红点直径

@interface BRTabBarController ()
{
    NSArray *_childVCArr;       // 子控制器
    NSArray *_titleArr;         // 标题
    NSArray *_imageArr;         // 图标
    NSArray *_selImageArr;      // 选中状态图标
    UIButton *_lastBtn;
    
    UIButton *_defaultSelBtn;   // 保存默认首页对应的按钮
    
    NSString *_identityFlag;
}
/** 自定义tabBar视图 */
@property (nonatomic, strong) UIView *customTabBarView;

@end

@implementation BRTabBarController

- (instancetype)initWithIdentityFlag:(NSString *)identityFlag {
    if (self = [super init]) {
        _identityFlag = identityFlag;
        // 设置数据源
        [self setupDataSource];
        // 设置UI
        [self setupUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 加载数据
- (void)setupDataSource {
    // 1.初始化数据
    if ([_identityFlag isEqualToString:App_ReviewingStatus]) {
        _childVCArr = @[@"TuWanViewController", @"BRLotteryViewController", @"BRClockViewController"];
        _titleArr = @[@"赏美女", @"看彩票", @"玩游戏"];
        _imageArr = @[@"tabbar_home", @"tabbar_kaijiang", @"tabbar_mine"];
        _selImageArr = @[@"tabbar_home_sel", @"tabbar_kaijiang_sel", @"tabbar_mine_sel"];
    } else {
        _childVCArr = @[@"BRHomeViewController", @"BRNewsViewController", @"BRLotteryViewController", @"BRMineViewController"];
        _titleArr = @[@"首页", @"彩讯", @"开奖", @"我的"];
        _imageArr = @[@"tabbar_home", @"tabbar_youhui", @"tabbar_kaijiang", @"tabbar_mine"];
        _selImageArr = @[@"tabbar_home_sel", @"tabbar_youhui_sel", @"tabbar_kaijiang_sel", @"tabbar_mine_sel"];
    }
    // 2.设置控制器
    [self setupChildControllers];
}

#pragma mark - 加载UI
- (void)setupUI {
    // 清除TabBar的阴影线
    [UITabBar appearance].shadowImage = [[UIImage alloc]init];
    [UITabBar appearance].backgroundImage = [UIImage new];
    
    [self setupCustomTabBar];
}

#pragma mark - 1.设置子控制器
- (void)setupChildControllers {
    // 添加子控制器到UTabBarController中
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSString *classNameStr in _childVCArr) {
        Class class = NSClassFromString(classNameStr);
        UIViewController *vc = [[class alloc]init];
        BRNavigationController *nav = [[BRNavigationController alloc] initWithRootViewController:vc];
        [tempArr addObject:nav];
    }
    self.viewControllers = tempArr;
}

#pragma mark - 2.设置自定义TabBar
- (void)setupCustomTabBar {
    // 创建自定义视图，代替系统默认的tabBar
    self.customTabBarView.hidden = NO;
    // 顶部边界线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGB_HEX(0xCCCCCC, 1.0f);
    [_customTabBarView addSubview:lineView];
//    // 创建背景视图
//    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49.0f)];
//    bgImageView.backgroundColor = [UIColor clearColor];
//    bgImageView.image = [UIImage imageNamed:@"tabbar_bg"];
//    [_customTabBarView addSubview:bgImageView];
    // 设置tabBarButton
    [self setupTabBarButton];
}

- (UIView *)customTabBarView {
    if (!_customTabBarView) {
        _customTabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49.0f)];
        _customTabBarView.backgroundColor = [UIColor whiteColor];
        [self.tabBar addSubview:_customTabBarView];
    }
    return _customTabBarView;
}

#pragma mark - 设置tabBarButton
- (void)setupTabBarButton {
    NSInteger num = self.viewControllers.count;
    for(int i = 0; i < num; i++) {
        BRTabBarButton *btn = [[BRTabBarButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / num * i, 0, SCREEN_WIDTH / num, 49.0)];
        // 默认文字颜色
        [btn setTitleColor:RGB_HEX(0x8a8a8a, 1.0f) forState:UIControlStateNormal];
        // 选中文字颜色
        [btn setTitleColor:RGB_HEX(0xfd8b47, 1.0f) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_imageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_selImageArr[i]] forState:UIControlStateSelected];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.customTabBarView addSubview:btn];
        if (i == 0) {
            // 保存默认选中按钮
            _defaultSelBtn = btn;
            // 默认选中
            btn.selected = YES;
            _lastBtn = btn;
            self.selectedIndex = 0;
        }
        // 角标
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width / 2.0 + 6, 3, NumMark_W_H, NumMark_W_H)];
        numLabel.layer.masksToBounds = YES;
        numLabel.layer.cornerRadius = 10;
        numLabel.backgroundColor = [UIColor redColor];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:10.0f];
        numLabel.tag = 1010 + i;
        numLabel.hidden = YES;
        [btn addSubview:numLabel];
    }
}

#pragma mark - 按钮点击事件
- (void)clickBtn:(UIButton *)button {
    if (button == _lastBtn) {
        return;
    }
    NSLog(@"点击了%ld个页面", button.tag - 1000);
    NSInteger index = button.tag - 1000;
    // 上一个按钮不选中
    _lastBtn.selected = NO;
    // 当前按钮选中
    button.selected = YES;
    _lastBtn = button;
    // 切换控制器
    self.selectedIndex = index;
    
    // 如果显示badge，点击tabbar就隐藏
    UILabel *numLabel = (UILabel *)[self.customTabBarView viewWithTag:1010 + index];
    if (numLabel.hidden == NO) {
        numLabel.hidden = YES;
    }
}

#pragma mark - 显示小红点
- (void)showPointMarkIndex:(NSInteger)index {
    UILabel *numLabel = (UILabel *)[self.customTabBarView viewWithTag:1010 + index];
    numLabel.hidden = NO;
    CGRect nFrame = numLabel.frame;
    nFrame.size.height = PointMark_W_H;
    nFrame.size.width = PointMark_W_H;
    numLabel.frame = nFrame;
    numLabel.layer.cornerRadius = PointMark_W_H / 2.0;
    numLabel.text = @"";
}

#pragma mark - 显示数字角标
- (void)showBadgeMark:(NSInteger)num index:(NSInteger)index {
    UILabel *numLabel = (UILabel *)[self.customTabBarView viewWithTag:1010 + index];
    numLabel.hidden = NO;
    CGRect nFrame = numLabel.frame;
    if(num <= 0) {
        //隐藏角标
        [self hideMarkIndex:index];
    } else {
        if(num > 0 && num <= 9) {
            nFrame.size.width = NumMark_W_H;
        } else if (num > 9 && num <= 19) {
            nFrame.size.width = NumMark_W_H + 5;
        } else if (num > 19 && num <= 99)  {
            nFrame.size.width = NumMark_W_H + 8;
        } else {
            nFrame.size.width = NumMark_W_H + 12;
        }
        nFrame.size.height = NumMark_W_H;
        numLabel.frame = nFrame;
        numLabel.layer.cornerRadius = NumMark_W_H / 2.0;
        numLabel.text = [NSString stringWithFormat:@"%ld", (long)num];
        if(num > 99) {
            numLabel.text =@"99+";
        }
    }
}

#pragma mark - 隐藏badge
- (void)hideMarkIndex:(NSInteger)index {
    UILabel *numLabel = (UILabel *)[self.customTabBarView viewWithTag:1010 + index];
    numLabel.hidden = YES;
}


@end
