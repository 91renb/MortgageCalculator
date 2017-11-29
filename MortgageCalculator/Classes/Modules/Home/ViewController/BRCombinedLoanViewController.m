//
//  BRCombinedLoanViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRCombinedLoanViewController.h"
#import "UIView+BRAdd.h"
#import "BRPickerView.h"
#import "BRInputModel.h"
#import "BRResultModel.h"
#import "BRMortgageHelper.h"
#import "BRCalculateResultViewController.h"

@interface BRCombinedLoanViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSString *_businessTotalPriceValue; //商业贷款总额
    NSString *_fundTotalPriceValue;     //公积金贷款总额
    NSString *_loanTimeValue;           //贷款期限
    NSString *_businessLoanRatesValue;  //商业贷款利率
    NSString *_fundLoanRatesValue;      //公积金贷款利率
    NSString *_repaymentWayValue;       //还款方式
    
    CGFloat _currentBusinessStandRates; //当前商业基准利率（由贷款期限决定）
    CGFloat _currentFundStandRates;     //当前公积金基准利率（由贷款期限决定）
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerSectionView;
@property (nonatomic, strong) UITextField *businessTotalPriceTF;   //商业贷款总额
@property (nonatomic, strong) UITextField *fundTotalPriceTF;    //公积金贷款总额
@property (nonatomic, strong) UITextField *loanTimeTF;          //贷款期限
@property (nonatomic, strong) UITextField *businessLoanRatesTF; //商业贷款利率
@property (nonatomic, strong) UITextField *fundLoanRatesTF;     //公积金贷款利率
@property (nonatomic, strong) UITextField *repaymentWayTF;      //还款方式

/** tableView 数据源数组 */
@property (nonatomic, strong) NSArray *tableDataArr;

@end

@implementation BRCombinedLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"组合贷款";
    [self initDefaultData];
    [self initUI];
}

- (void)initDefaultData {
    _businessTotalPriceValue = @"";
    _fundTotalPriceValue = @"";
    _loanTimeValue = @"20年（240期）";
    _businessLoanRatesValue = @"4.90";
    _fundLoanRatesValue = @"3.25";
    _repaymentWayValue = @"等额本息";
    
    _currentBusinessStandRates = 4.90;
    _currentFundStandRates = 3.25;
}

- (void)initUI {
    self.tableView.hidden = NO;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 40 * kScaleFit) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // iOS11之后要设置这两个属性，才会去掉默认的分区头部、尾部的高度
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 50 * kScaleFit;
        _tableView.tableFooterView = self.footerSectionView;
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
    static NSString *const cellID = @"combinedLoanCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    cell.textLabel.textColor = kTextDefaultColor;
    cell.textLabel.text = self.tableDataArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self setupBusinessLoanTotalPriceCell:cell];
    } else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self setupFundLoanTotalPriceCell:cell];
    } else if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupLoanTimeCell:cell];
    } else if (indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self setupBusinessLoanRatesCell:cell];
    } else if (indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self setupFundLoanRatesCell:cell];
    } else if (indexPath.row == 5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupRepaymentWayCell:cell];
    }
    
    return cell;
}

#pragma mark - 商业贷款总额
- (void)setupBusinessLoanTotalPriceCell:(UITableViewCell *)cell {
    UITextField *businessTotalPriceTF = [self getTextField:cell rightMargin:-36 * kScaleFit];
    businessTotalPriceTF.delegate = self;
    businessTotalPriceTF.tag = 0;
    businessTotalPriceTF.keyboardType = UIKeyboardTypeNumberPad; //数字键盘，没有小数点
    businessTotalPriceTF.placeholder = @"请输入商业贷款金额";
    businessTotalPriceTF.text = _businessTotalPriceValue;
    self.businessTotalPriceTF = businessTotalPriceTF;
    [self addUnitLabel:cell rightMargin:-15 * kScaleFit text:@"万"];
}

#pragma mark - 公积金贷款总额
- (void)setupFundLoanTotalPriceCell:(UITableViewCell *)cell {
    UITextField *fundTotalPriceTF = [self getTextField:cell rightMargin:-36 * kScaleFit];
    fundTotalPriceTF.delegate = self;
    fundTotalPriceTF.tag = 1;
    fundTotalPriceTF.keyboardType = UIKeyboardTypeNumberPad; //数字键盘，没有小数点
    fundTotalPriceTF.placeholder = @"请输入公积金贷款金额";
    fundTotalPriceTF.text = _fundTotalPriceValue;
    self.fundTotalPriceTF = fundTotalPriceTF;
    [self addUnitLabel:cell rightMargin:-15 * kScaleFit text:@"万"];
}


#pragma mark - 贷款期限
- (void)setupLoanTimeCell:(UITableViewCell *)cell {
    UITextField *loanTimeTF = [self getTextField:cell rightMargin:0 * kScaleFit];
    loanTimeTF.enabled = NO;
    loanTimeTF.placeholder = @"请选择贷款期限";
    loanTimeTF.text = _loanTimeValue;
    self.loanTimeTF = loanTimeTF;
}

#pragma mark - 商业贷款利率
- (void)setupBusinessLoanRatesCell:(UITableViewCell *)cell {
    UITextField *businessLoanRatesTF = [self getTextField:cell rightMargin:-56 * kScaleFit];
    businessLoanRatesTF.delegate = self;
    businessLoanRatesTF.tag = 2;
    businessLoanRatesTF.keyboardType = UIKeyboardTypeDecimalPad;
    businessLoanRatesTF.placeholder = @"请输入商业贷款利率";
    businessLoanRatesTF.text = _businessLoanRatesValue;
    self.businessLoanRatesTF = businessLoanRatesTF;
    [self addUnitLabel:cell rightMargin:-35 * kScaleFit text:@"%"];
    [self addSelectDownImageView:cell rightMargin:-15 * kScaleFit tag:1000];
}

#pragma mark - 公积金贷款利率
- (void)setupFundLoanRatesCell:(UITableViewCell *)cell {
    UITextField *fundLoanRatesTF = [self getTextField:cell rightMargin:-56 * kScaleFit];
    fundLoanRatesTF.delegate = self;
    fundLoanRatesTF.tag = 3;
    fundLoanRatesTF.keyboardType = UIKeyboardTypeDecimalPad;
    fundLoanRatesTF.placeholder = @"请输入公积金贷款利率";
    fundLoanRatesTF.text = _fundLoanRatesValue;
    self.fundLoanRatesTF = fundLoanRatesTF;
    [self addUnitLabel:cell rightMargin:-35 * kScaleFit text:@"%"];
    [self addSelectDownImageView:cell rightMargin:-15 * kScaleFit tag:1001];
}

#pragma mark - 还款方式
- (void)setupRepaymentWayCell:(UITableViewCell *)cell {
    UITextField *repaymentWayTF = [self getTextField:cell rightMargin:0 * kScaleFit];
    repaymentWayTF.enabled = NO;
    repaymentWayTF.text = _repaymentWayValue;
    self.repaymentWayTF = repaymentWayTF;
}

- (UITextField *)getTextField:(UITableViewCell *)cell rightMargin:(CGFloat)rightMargin {
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = kTextDefaultColor;
    textField.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    textField.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.left.mas_equalTo(100 * kScaleFit);
        make.right.mas_equalTo(rightMargin);
        make.height.mas_equalTo(40.0f * kScaleFit);
    }];
    return textField;
}

- (void)addUnitLabel:(UITableViewCell *)cell rightMargin:(CGFloat)rightMargin text:(NSString *)text {
    UILabel *unitLabel = [[UILabel alloc]init];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    unitLabel.textAlignment = NSTextAlignmentCenter;
    unitLabel.textColor = kTextDefaultColor;
    unitLabel.text = text;
    [cell.contentView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(rightMargin);
        make.size.mas_equalTo(CGSizeMake(16.0f * kScaleFit, 40.0f * kScaleFit));
    }];
}

- (void)addSelectDownImageView:(UITableViewCell *)cell rightMargin:(CGFloat)rightMargin tag:(NSInteger)tag {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"select_down3"];
    [cell.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(rightMargin);
        make.size.mas_equalTo(CGSizeMake(16.0f * kScaleFit, 12.0f * kScaleFit));
    }];
    imageView.userInteractionEnabled = YES;
    imageView.tag = tag;
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSelectDownImageView:)];
    [imageView addGestureRecognizer:myTap];
}

- (void)didTapSelectDownImageView:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag;
    if (index == 1000) {
        NSLog(@"选择商业贷款利率");
        [BRStringPickerView showStringPickerWithTitle:@"请选择贷款利率" plistName:@"loanRates" defaultSelValue:@"基准利率" isAutoSelect:NO resultBlock:^(id selectValue) {
            // 筛选出数字
            NSString *result = [selectValue stringByReplacingOccurrencesOfString:@"基准利率" withString:@""];
            if ([result containsString:@"折"]) {
                result = [result stringByReplacingOccurrencesOfString:@"折" withString:@""];
                CGFloat rate = [result floatValue];
                // 加 0.0005 的目的是四舍五入
                result = [NSString stringWithFormat:@"%.2f", (rate / 10.0) * _currentBusinessStandRates + 0.0005];
                self.businessLoanRatesTF.text = _businessLoanRatesValue = result;
            } else if ([result containsString:@"倍"]) {
                result = [result stringByReplacingOccurrencesOfString:@"倍" withString:@""];
                CGFloat rate = [result floatValue];
                result = [NSString stringWithFormat:@"%.2f", rate * _currentBusinessStandRates + 0.0005];
                self.businessLoanRatesTF.text = _businessLoanRatesValue = result;
            } else {
                self.businessLoanRatesTF.text = _businessLoanRatesValue = [NSString stringWithFormat:@"%.2f", _currentBusinessStandRates];
            }
        }];
    } else if (index == 1001) {
        NSLog(@"选择公积金贷款利率");
        [BRStringPickerView showStringPickerWithTitle:@"请选择贷款利率" plistName:@"fundLoanRates" defaultSelValue:@"基准利率" isAutoSelect:NO resultBlock:^(id selectValue) {
            // 筛选出数字
            NSString *result = [selectValue stringByReplacingOccurrencesOfString:@"基准利率" withString:@""];
            if ([result containsString:@"倍"]) {
                result = [result stringByReplacingOccurrencesOfString:@"倍" withString:@""];
                CGFloat rate = [result floatValue];
                result = [NSString stringWithFormat:@"%.2f", rate * _currentFundStandRates + 0.0005];
                self.fundLoanRatesTF.text = _fundLoanRatesValue = result;
            } else {
                self.fundLoanRatesTF.text = _fundLoanRatesValue = [NSString stringWithFormat:@"%.2f", _currentFundStandRates];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        NSLog(@"选择贷款期限");
        [BRStringPickerView showStringPickerWithTitle:@"请选择贷款期限" plistName:@"loanTime" defaultSelValue:self.loanTimeTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
            self.loanTimeTF.text = _loanTimeValue = selectValue;
            NSInteger loanYear = [[[selectValue componentsSeparatedByString:@"年"] firstObject] integerValue];
            // 根据贷款期限更新贷款基准利率
            if (loanYear == 1) {
                _currentBusinessStandRates = 4.35;
                _currentFundStandRates = 2.75;
                self.businessLoanRatesTF.text = _businessLoanRatesValue = @"4.35";
                self.fundLoanRatesTF.text = _fundLoanRatesValue = @"2.75";
            } else if (loanYear > 1 && loanYear <= 5) {
                _currentBusinessStandRates = 4.75;
                _currentFundStandRates = 2.75;
                self.businessLoanRatesTF.text = _businessLoanRatesValue = @"4.75";
                self.fundLoanRatesTF.text = _fundLoanRatesValue = @"2.75";
            } else if (loanYear > 5) {
                _currentBusinessStandRates = 4.90;
                _currentFundStandRates = 3.25;
                self.businessLoanRatesTF.text = _businessLoanRatesValue = @"4.90";
                self.fundLoanRatesTF.text = _fundLoanRatesValue = @"3.25";
            }
        }];
    } else if (indexPath.row == 5) {
        NSLog(@"选择还款方式");
        [BRStringPickerView showStringPickerWithTitle:@"请选择还款方式" dataSource:@[@"等额本息", @"等额本金"] defaultSelValue:self.repaymentWayTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
            self.repaymentWayTF.text = _repaymentWayValue = selectValue;
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f * kScaleFit;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (UIView *)footerSectionView {
    if (!_footerSectionView) {
        _footerSectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104 * kScaleFit)];
        _footerSectionView.backgroundColor = [UIColor clearColor];
        UIButton *calculatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [calculatorBtn setBackgroundColor:kThemeColor];
        calculatorBtn.layer.cornerRadius = 3.0f;
        calculatorBtn.layer.masksToBounds = YES;
        calculatorBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
        [calculatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [calculatorBtn setTitle:@"开始计算" forState:UIControlStateNormal];
        [calculatorBtn addTarget:self action:@selector(clickCalculatorBtn) forControlEvents:UIControlEventTouchUpInside];
        [_footerSectionView addSubview:calculatorBtn];
        [calculatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30 * kScaleFit);
            make.left.mas_equalTo(30 * kScaleFit);
            make.right.mas_equalTo(-30 * kScaleFit);
            make.height.mas_equalTo(44 * kScaleFit);
        }];
    }
    return _footerSectionView;
}

- (void)clickCalculatorBtn {
    NSLog(@"开始计算");
    if (self.businessTotalPriceTF.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入商业贷款总额"];
        return;
    }
    if (self.fundTotalPriceTF.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入公积金贷款总额"];
        return;
    }
    if (self.businessLoanRatesTF.text.length == 0) {
        [MBProgressHUD showMessage:@"商业贷款利率不能为空"];
        return;
    }
    if ([self.businessLoanRatesTF.text floatValue] < 1) {
        [MBProgressHUD showMessage:@"商业贷款利率不能小于1%"];
        return;
    }
    if (self.fundLoanRatesTF.text.length == 0) {
        [MBProgressHUD showMessage:@"公积金贷款利率不能为空"];
        return;
    }
    if ([self.fundLoanRatesTF.text floatValue] < 1) {
        [MBProgressHUD showMessage:@"公积金贷款利率不能小于1%"];
        return;
    }
    // 按房屋总价计算
    [self houseTotalWayStartCalculatorResult];
}

- (void)houseTotalWayStartCalculatorResult {
    BRInputModel *inputModel = [[BRInputModel alloc]init];
    inputModel.businessTotalPrice = [self.businessTotalPriceTF.text integerValue];
    inputModel.fundTotalPrice = [self.fundTotalPriceTF.text integerValue];
    inputModel.mortgageYear = [self.loanTimeTF.text integerValue];
    inputModel.bankRate = [self.businessLoanRatesTF.text doubleValue];
    inputModel.fundRate = [self.fundLoanRatesTF.text doubleValue];
    if ([self.repaymentWayTF.text isEqualToString:@"等额本息"]) {
        BRResultModel *resultModel = [BRMortgageHelper calculateCombinedLoanAsEqualPrincipalInterest:inputModel];
        BRCalculateResultViewController *calculateResultVC = [[BRCalculateResultViewController alloc]init];
        calculateResultVC.calculateWay = BRCalculateWayTotalPrice;
        calculateResultVC.repayWay = BRRepayWayPriceInterestSame;
        calculateResultVC.resultModel = resultModel;
        [self.navigationController pushViewController:calculateResultVC animated:YES];
    } else if ([self.repaymentWayTF.text isEqualToString:@"等额本金"]) {
        BRResultModel *resultModel = [BRMortgageHelper calculateCombinedLoanAsEqualPrincipal:inputModel];
        BRCalculateResultViewController *calculateResultVC = [[BRCalculateResultViewController alloc]init];
        calculateResultVC.calculateWay = BRCalculateWayTotalPrice;
        calculateResultVC.repayWay = BRRepayWayPriceSame;
        calculateResultVC.resultModel = resultModel;
        [self.navigationController pushViewController:calculateResultVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 得到输入框的内容
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 0) {
        NSLog(@"商业贷款总额：%@", currentString);
        _businessTotalPriceValue = currentString;
        NSInteger maxLength = 4; // 字符串的最大长度
        if (currentString.length > maxLength) {
            //textField.text = @"";
            return NO; // NO 表示此时不能改变输入框的值
        }
        // 禁止输入0
        if ([currentString isEqualToString:@"0"]) {
            textField.text = @"";
            return NO;
        }
    } else if (textField.tag == 1) {
        NSLog(@"公积金贷款总额：%@", currentString);
        _fundTotalPriceValue = currentString;
        NSInteger maxLength = 4; // 字符串的最大长度
        if (currentString.length > maxLength) {
            //textField.text = @"";
            return NO; // NO 表示此时不能改变输入框的值
        }
        // 禁止输入0
        if ([currentString isEqualToString:@"0"]) {
            textField.text = @"";
            return NO;
        }
    } else if (textField.tag == 2) {
        NSLog(@"商业贷款利率：%@", currentString);
        _businessLoanRatesValue = currentString;
        NSInteger maxLength = 6;
        CGFloat maxValue = 9;
        if (currentString.length > maxLength) {
            [MBProgressHUD showMessage:@"请输入少于5个字符的数字"];
            return NO;
        }
        if ([currentString floatValue] > maxValue) {
            [MBProgressHUD showMessage:@"请输入小于10的数字"];
            return NO;
        }
    } else if (textField.tag == 3) {
        NSLog(@"公积金贷款利率：%@", currentString);
        _fundLoanRatesValue = currentString;
        NSInteger maxLength = 6;
        CGFloat maxValue = 9;
        if (currentString.length > maxLength) {
            [MBProgressHUD showMessage:@"请输入少于5个字符的数字"];
            return NO;
        }
        if ([currentString floatValue] > maxValue) {
            [MBProgressHUD showMessage:@"请输入小于10的数字"];
            return NO;
        }
    }
    return YES; // YES 表示此时能改变输入框的值
}

- (NSArray *)tableDataArr {
    if (!_tableDataArr) {
        _tableDataArr = @[@"商业贷款总额", @"公积金贷款总额", @"贷款期限", @"商业贷款利率", @"公积金贷款利率", @"还款方式"];
    }
    return _tableDataArr;
}


@end
