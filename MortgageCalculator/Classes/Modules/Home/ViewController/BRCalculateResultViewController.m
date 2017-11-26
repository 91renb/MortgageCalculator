//
//  BRCalculateResultViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRCalculateResultViewController.h"
#import "BRCalculateResultCell.h"
#import "BRResultModel.h"
#import "UIView+BRAdd.h"
#import "UIImage+BRAdd.h"

#define kHeaderH (NAV_HEIGHT + 170 * kScaleFit)
@interface BRCalculateResultViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
/** tableView 数据源数组 */
@property (nonatomic, strong) NSArray *tableDataArr;

@end

@implementation BRCalculateResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"计算结果";
    [self loadData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏（注：这里要设置显示动画，防止返回时出现导航栏覆盖当前页面）
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadData {
    self.tableDataArr = self.resultModel.monthRepaymentArr;
}

- (void)initUI {
    // iOS11适配
    if (@available(iOS 11.0, *)) {
        // 不计算内边距
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 调整UIScrollView显示内容的位置(iOS11已废弃该属性)
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.hidden = NO;
    [self.view addSubview:self.headView];
}

- (void)didTapBackImageView {
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderH)];
        _headView.backgroundColor = kThemeColor;
        [_headView setGradientColor:RGB_HEX(0x46b2f0, 1.0f) toColor:RGB_HEX(0x4181e1, 1.0f)];
        
        // 返回按钮
        UIImageView *backImageView = [[UIImageView alloc]init];
        backImageView.backgroundColor = [UIColor clearColor];
        backImageView.image = [UIImage imageNamed:@"navbar_return"];
        backImageView.contentMode = UIViewContentModeLeft;
        [_headView addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(STATUSBAR_HEIGHT);
            make.left.mas_equalTo(10 * kScaleFit);
            make.width.mas_equalTo(40 * kScaleFit);
            make.height.mas_equalTo(44);
        }];
        backImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBackImageView)];
        [backImageView addGestureRecognizer:myTap];
        
        // 导航栏标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0f * kScaleFit];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"计算结果";
        [_headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(STATUSBAR_HEIGHT);
            make.centerX.mas_equalTo(_headView);
            make.width.mas_equalTo(200 * kScaleFit);
            make.height.mas_equalTo(44);
        }];
        
        // 每月月供/首月月供
        UILabel *avgMonthRepayLabel = [[UILabel alloc]init];
        avgMonthRepayLabel.backgroundColor = [UIColor clearColor];
        avgMonthRepayLabel.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
        avgMonthRepayLabel.textColor = RGB_HEX(0xeeeeee, 1.0f);
        avgMonthRepayLabel.numberOfLines = 0;
        avgMonthRepayLabel.textAlignment = NSTextAlignmentCenter;
        NSString *avgMonthRepayText = [NSString stringWithFormat:@"每月月供\n %@元", self.resultModel.avgMonthRepayment];
        NSString *changeText = [NSString stringWithFormat:@"%@", self.resultModel.avgMonthRepayment];
        avgMonthRepayLabel.attributedText = [self setLabelText:avgMonthRepayText changeText:changeText changeFont:[UIFont systemFontOfSize:28.0f * kScaleFit] changeTextColor:[UIColor whiteColor] paragraphSpacing:10 * kScaleFit];
        [_headView addSubview:avgMonthRepayLabel];
        [avgMonthRepayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headView).with.offset(NAV_HEIGHT + 20 * kScaleFit);
            make.centerX.mas_equalTo(_headView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 70 * kScaleFit));
        }];
        // 累计还款金额
        UILabel *repayTotalPriceLabel = [[UILabel alloc]init];
        repayTotalPriceLabel.backgroundColor = [UIColor clearColor];
        repayTotalPriceLabel.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
        repayTotalPriceLabel.textColor = RGB_HEX(0xeeeeee, 1.0f);
        repayTotalPriceLabel.numberOfLines = 0;
        repayTotalPriceLabel.textAlignment = NSTextAlignmentCenter;
        NSString *repayTotalPriceText = [NSString stringWithFormat:@"累计还款金额(元)\n %@", self.resultModel.repayTotalPrice];
        NSString *changeText3 = [NSString stringWithFormat:@"%@", self.resultModel.repayTotalPrice];
        repayTotalPriceLabel.attributedText = [self setLabelText:repayTotalPriceText changeText:changeText3 changeFont:[UIFont systemFontOfSize:18.0f * kScaleFit] changeTextColor:[UIColor whiteColor] paragraphSpacing:6 * kScaleFit];
        [_headView addSubview:repayTotalPriceLabel];
        [repayTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(avgMonthRepayLabel.mas_bottom).with.offset(20 * kScaleFit);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 60 * kScaleFit));
        }];
        // 累计利息
        UILabel *repayTotalInterestLabel = [[UILabel alloc]init];
        repayTotalInterestLabel.backgroundColor = [UIColor clearColor];
        repayTotalInterestLabel.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
        repayTotalInterestLabel.textColor = RGB_HEX(0xeeeeee, 1.0f);
        repayTotalInterestLabel.numberOfLines = 0;
        repayTotalInterestLabel.textAlignment = NSTextAlignmentCenter;
        NSString *repayTotalInterestText = [NSString stringWithFormat:@"累计利息(元)\n %@", self.resultModel.repayTotalInterest];
        NSString *changeText2 = [NSString stringWithFormat:@"%@", self.resultModel.repayTotalInterest];
        repayTotalInterestLabel.attributedText = [self setLabelText:repayTotalInterestText changeText:changeText2 changeFont:[UIFont systemFontOfSize:18.0f * kScaleFit] changeTextColor:[UIColor whiteColor] paragraphSpacing:6 * kScaleFit];
        [_headView addSubview:repayTotalInterestLabel];
        [repayTotalInterestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(avgMonthRepayLabel.mas_bottom).with.offset(20 * kScaleFit);
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 60 * kScaleFit));
        }];
        // 分割线
        UIView *spLineView = [[UIView alloc]init];
        spLineView.backgroundColor = RGB_HEX(0xe2e2e2, 1.0f);
        [_headView addSubview:spLineView];
        [spLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(avgMonthRepayLabel.mas_bottom).with.offset(15 * kScaleFit);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.3 * kScaleFit));
        }];
        UIView *szLineView = [[UIView alloc]init];
        szLineView.backgroundColor = RGB_HEX(0xe2e2e2, 1.0f);
        [_headView addSubview:szLineView];
        [szLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(avgMonthRepayLabel.mas_bottom).with.offset(30 * kScaleFit);
            make.left.mas_equalTo(SCREEN_WIDTH / 2);
            make.size.mas_equalTo(CGSizeMake(0.5 * kScaleFit, 40 * kScaleFit));
        }];
    }
    return _headView;
}

#pragma mark - label富文本: 设置不同字体和颜色
- (NSMutableAttributedString *)setLabelText:(NSString *)text changeText:(NSString *)changeText changeFont:(UIFont *)font changeTextColor:(UIColor *)color paragraphSpacing:(CGFloat)paragraphSpacing {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    // 获取要调整文字样式的位置
    NSRange range = [[attrString string]rangeOfString:changeText];
    // 设置不同字体
    [attrString addAttribute:NSFontAttributeName value:font range:range];
    // 设置不同颜色
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    //段落间距
    paragraphStyle.paragraphSpacing = paragraphSpacing;
    [attrString addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, text.length - 1)];
    return attrString;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // iOS11之后要设置这两个属性，才会去掉默认的分区头部、尾部的高度
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 44 * kScaleFit;
        // 设置表格的间距(上，左，下，右)
        _tableView.contentInset = UIEdgeInsetsMake(kHeaderH, 0, 0, 0);
        // 设置滚动指示器的间距（即滑动条的位置）
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        //_tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellID = @"calculateResultCell";
    BRCalculateResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BRCalculateResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.monthResultModel = self.tableDataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f * kScaleFit;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30 * kScaleFit)];
    sectionHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *numberLabel = [self getLabel:@"期数" centerX:SCREEN_WIDTH / 8];
    [sectionHeaderView addSubview:numberLabel];
    UILabel *totalPriceLabel = [self getLabel:@"月供(元)" centerX:SCREEN_WIDTH / 8 + SCREEN_WIDTH / 4];
    [sectionHeaderView addSubview:totalPriceLabel];
    UILabel *priceLabel = [self getLabel:@"本金(元)" centerX:SCREEN_WIDTH / 8 + SCREEN_WIDTH * 2 / 4];
    [sectionHeaderView addSubview:priceLabel];
    UILabel *interestLabel = [self getLabel:@"利息(元)" centerX:SCREEN_WIDTH / 8 + SCREEN_WIDTH * 3 / 4];
    [sectionHeaderView addSubview:interestLabel];
    
    return sectionHeaderView;
}

- (UILabel *)getLabel:(NSString *)text centerX:(CGFloat)centerX {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80 * kScaleFit, 30 * kScaleFit)];
    label.center = CGPointMake(centerX, 15 * kScaleFit);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
    label.textColor = RGB_HEX(0x666666, 1.0f);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    return label;
}

- (NSArray *)tableDataArr {
    if (!_tableDataArr) {
        _tableDataArr = [NSArray array];
    }
    return _tableDataArr;
}

@end
