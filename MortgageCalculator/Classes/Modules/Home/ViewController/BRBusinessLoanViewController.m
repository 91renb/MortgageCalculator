//
//  BRBusinessLoanViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRBusinessLoanViewController.h"
#import "UIView+BRAdd.h"
#import "BRPickerView.h"

/// 贷款计算方式
typedef enum : NSUInteger {
    BRCalculateWayTotalPrice,       //房屋总额
    BRCalculateWayUnitPriceAndArea  //房屋单价和面积
} BRCalculateWay;

@interface BRBusinessLoanViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerSectionView;
@property (nonatomic, strong) UITextField *calculateWayTF;  //计算方式
@property (nonatomic, strong) UITextField *loanTotalTF;     //贷款总额
@property (nonatomic, strong) UITextField *loanTimeTF;      //贷款期限
@property (nonatomic, strong) UITextField *loanRatesTF;     //贷款利率
@property (nonatomic, strong) UITextField *repaymentWayTF;  //还款方式
@property (nonatomic, strong) UITextField *unitPriceTF;       //房屋单价
@property (nonatomic, strong) UITextField *areaTF;            //房屋面积
@property (nonatomic, strong) UITextField *loanPercentageTF;  //按揭成数

/** tableView 数据源数组 */
@property (nonatomic, strong) NSArray *tableDataArr;
@property (nonatomic, assign) BRCalculateWay calculateWay;

@end

@implementation BRBusinessLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商业贷款";
    self.calculateWay = BRCalculateWayTotalPrice;
    [self initUI];
}

- (void)initUI {
    self.tableView.hidden = NO;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
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
    return self.tableDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.tableDataArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellID = @"businessLoanCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
    cell.textLabel.text = self.tableDataArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupCalculateWayCell:cell];
    }
    if (self.calculateWay == BRCalculateWayTotalPrice) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setupLoanTotalCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupLoanTimeCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setupLoanRatesCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupRepaymentWayCell:cell];
        }
    } else if (self.calculateWay == BRCalculateWayUnitPriceAndArea) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setupUnitPriceCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setupAreaCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupLoanTimeCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupLoanPercentageCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setupLoanRatesCell:cell];
        } else if (indexPath.section == 1 && indexPath.row == 5) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self setupRepaymentWayCell:cell];
        }
    }
    
    return cell;
}

#pragma mark - 房屋总价
- (void)setupCalculateWayCell:(UITableViewCell *)cell {
    UITextField *calculateWayTF = [self getTextField:cell rightMargin:0 * kScaleFit];
    calculateWayTF.enabled = NO;
    calculateWayTF.delegate = self;
    calculateWayTF.text = @"房屋总价";
    self.calculateWayTF = calculateWayTF;
}

#pragma mark - 贷款总额
- (void)setupLoanTotalCell:(UITableViewCell *)cell {
    UITextField *loanTotalTF = [self getTextField:cell rightMargin:-36 * kScaleFit];
    loanTotalTF.delegate = self;
    loanTotalTF.keyboardType = UIKeyboardTypeDecimalPad;
    loanTotalTF.placeholder = @"请输入贷款金额";
    self.loanTotalTF = loanTotalTF;
    [self addUnitLabel:cell rightMargin:-15 * kScaleFit text:@"万"];
}

#pragma mark - 贷款期限
- (void)setupLoanTimeCell:(UITableViewCell *)cell {
    UITextField *loanTimeTF = [self getTextField:cell rightMargin:0 * kScaleFit];
    loanTimeTF.enabled = NO;
    loanTimeTF.placeholder = @"请选择贷款期限";
    loanTimeTF.text = @"20年（240期）";
    self.loanTimeTF = loanTimeTF;
}

#pragma mark - 贷款利率
- (void)setupLoanRatesCell:(UITableViewCell *)cell {
    UITextField *loanRatesTF = [self getTextField:cell rightMargin:-56 * kScaleFit];
    loanRatesTF.delegate = self;
    loanRatesTF.keyboardType = UIKeyboardTypeDecimalPad;
    loanRatesTF.placeholder = @"请输入贷款利率";
    loanRatesTF.text = @"4.90";
    self.loanRatesTF = loanRatesTF;
    [self addUnitLabel:cell rightMargin:-35 * kScaleFit text:@"%"];
    [self addSelectDownImageView:cell rightMargin:-15 * kScaleFit];
}

#pragma mark - 还款方式
- (void)setupRepaymentWayCell:(UITableViewCell *)cell {
    UITextField *repaymentWayTF = [self getTextField:cell rightMargin:0 * kScaleFit];
    repaymentWayTF.enabled = NO;
    repaymentWayTF.text = @"等额本息";
    self.repaymentWayTF = repaymentWayTF;
}

#pragma mark - 房屋单价
- (void)setupUnitPriceCell:(UITableViewCell *)cell {
    UITextField *unitPriceTF = [self getTextField:cell rightMargin:-36 * kScaleFit];
    unitPriceTF.delegate = self;
    unitPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
    unitPriceTF.placeholder = @"请输入房屋单价";
    self.unitPriceTF = unitPriceTF;
    [self addUnitLabel:cell rightMargin:-15 * kScaleFit text:@"元"];
}

#pragma mark - 房屋面积
- (void)setupAreaCell:(UITableViewCell *)cell {
    UITextField *areaTF = [self getTextField:cell rightMargin:-36 * kScaleFit];
    areaTF.delegate = self;
    areaTF.keyboardType = UIKeyboardTypeDecimalPad;
    areaTF.placeholder = @"请输入房屋面积";
    self.areaTF = areaTF;
    [self addUnitLabel:cell rightMargin:-15 * kScaleFit text:@"㎡"];
}

#pragma mark - 按揭成数
- (void)setupLoanPercentageCell:(UITableViewCell *)cell {
    UITextField *loanPercentageTF = [self getTextField:cell rightMargin:0 * kScaleFit];
    loanPercentageTF.enabled = NO;
    loanPercentageTF.placeholder = @"请选择按揭成数";
    self.loanPercentageTF = loanPercentageTF;
}

- (UITextField *)getTextField:(UITableViewCell *)cell rightMargin:(CGFloat)rightMargin {
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = RGB_HEX(0x464646, 1.0f);
    textField.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    textField.textAlignment = NSTextAlignmentRight;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
    textField.autocorrectionType = UITextAutocorrectionTypeNo; // 关闭自动纠错
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; // 清除按钮(编辑时出现)
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
    unitLabel.textColor = RGB_HEX(0x464646, 1.0f);
    unitLabel.text = text;
    [cell.contentView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(rightMargin);
        make.size.mas_equalTo(CGSizeMake(16.0f * kScaleFit, 40.0f * kScaleFit));
    }];
}

- (void)addSelectDownImageView:(UITableViewCell *)cell rightMargin:(CGFloat)rightMargin {
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
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapSelectDownImageView)];
    [imageView addGestureRecognizer:myTap];
}

- (void)didTapSelectDownImageView {
    NSLog(@"选择贷款利率");
    [BRStringPickerView showStringPickerWithTitle:@"请选择贷款利率" plistName:@"loanRates" defaultSelValue:@"最新基准利率（4.90%）" isAutoSelect:NO resultBlock:^(id selectValue) {
        NSString *loanRatesStr = selectValue;
        NSString *result = [[loanRatesStr componentsSeparatedByString:@"%"] firstObject];
        result = [[result componentsSeparatedByString:@"（"] lastObject];
        self.loanRatesTF.text = result;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSLog(@"选择计算方式");
        [BRStringPickerView showStringPickerWithTitle:@"请选择计算方式" dataSource:@[@"房屋总价", @"单价和面积"] defaultSelValue:self.calculateWayTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
            self.calculateWayTF.text = selectValue;
            // 更新数据源
            if ([selectValue isEqualToString:@"房屋总价"]) {
                self.calculateWay = BRCalculateWayTotalPrice;
                self.tableDataArr = @[@[@"计算方式"], @[@"贷款总额", @"贷款期限", @"贷款利率", @"还款方式"]];
            } else if ([selectValue isEqualToString:@"单价和面积"]) {
                self.calculateWay = BRCalculateWayUnitPriceAndArea;
                self.tableDataArr = @[@[@"计算方式"], @[@"房屋单价", @"房屋面积", @"贷款期限", @"按揭成数", @"贷款利率", @"还款方式"]];
            }
            // 更新UI
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
    if (self.calculateWay == BRCalculateWayTotalPrice) {
        if (indexPath.section == 1 && indexPath.row == 1) {
            NSLog(@"选择贷款期限");
            [BRStringPickerView showStringPickerWithTitle:@"请选择贷款期限" plistName:@"loanTime" defaultSelValue:self.loanTimeTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
                self.loanTimeTF.text = selectValue;
            }];
        } else if (indexPath.section == 1 && indexPath.row == 3) {
            NSLog(@"选择还款方式");
            [BRStringPickerView showStringPickerWithTitle:@"请选择还款方式" dataSource:@[@"等额本息", @"等额本金"] defaultSelValue:self.repaymentWayTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
                self.repaymentWayTF.text = selectValue;
            }];
        }
    } else if (self.calculateWay == BRCalculateWayUnitPriceAndArea) {
        if (indexPath.section == 1 && indexPath.row == 2) {
            NSLog(@"选择贷款期限");
            [BRStringPickerView showStringPickerWithTitle:@"请选择贷款期限" plistName:@"loanTime" defaultSelValue:self.loanTimeTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
                self.loanTimeTF.text = selectValue;
            }];
        } else if (indexPath.section == 1 && indexPath.row == 3) {
            NSLog(@"选择按揭成数");
            NSArray *dataSource = @[@"1成", @"2成", @"3成", @"4成", @"5成", @"6成", @"7成", @"8成", @"9成"];
            [BRStringPickerView showStringPickerWithTitle:@"请选择按揭成数" dataSource:dataSource defaultSelValue:self.loanPercentageTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
                self.loanPercentageTF.text = selectValue;
            }];
        } else if (indexPath.section == 1 && indexPath.row == 5) {
            NSLog(@"选择还款方式");
            [BRStringPickerView showStringPickerWithTitle:@"请选择还款方式" dataSource:@[@"等额本息", @"等额本金"] defaultSelValue:self.repaymentWayTF.text isAutoSelect:NO resultBlock:^(id selectValue) {
                self.repaymentWayTF.text = selectValue;
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20.0f * kScaleFit;
    }
    return 10.0f * kScaleFit;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerSectionView = [[UIView alloc]init];
    footerSectionView.backgroundColor = [UIColor clearColor];
    return footerSectionView;
}

- (UIView *)footerSectionView {
    if (!_footerSectionView) {
        _footerSectionView = [[UIView alloc]init];
        _footerSectionView.backgroundColor = [UIColor clearColor];
        
        UIButton *calculatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [calculatorBtn setBackgroundColor:kThemeColor];
        //[calculatorBtn setGradientColor:RGB_HEX(0x46b2f0, 1.0f) toColor:RGB_HEX(0x4181e1, 1.0f)];
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
    
}


- (NSArray *)tableDataArr {
    if (!_tableDataArr) {
        _tableDataArr = @[@[@"计算方式"], @[@"贷款总额", @"贷款期限", @"贷款利率", @"还款方式"]];
    }
    return _tableDataArr;
}

@end
