//
//  BRCombinedLoanViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRCombinedLoanViewController.h"

@interface BRCombinedLoanViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *companyTF;
/** tableView 数据源数组 */
@property (nonatomic, strong) NSArray *tableDataArr;

@end

@implementation BRCombinedLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"组合贷款";
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50 * kScaleFit;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellID = @"forgetPwdCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = [self.tableDataArr objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UITextField *companyTF = [self getTextField:cell rightMargin:0 * kScaleFit];
        //companyTF.keyboardType = UIKeyboardTypeNumberPad;
        companyTF.delegate = self;
        companyTF.tag = 0;
        companyTF.placeholder = @"请选择企业";
        self.companyTF = companyTF;
    }
    
    return cell;
}

- (UITextField *)getTextField:(UITableViewCell *)cell rightMargin:(CGFloat)rightMargin {
    UITextField *textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = RGB_HEX(0x464646, 1.0f);
    textField.font = [UIFont systemFontOfSize:14.0f * kScaleFit];
    textField.textAlignment = NSTextAlignmentRight;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // 关闭首字母大写
    textField.autocorrectionType = UITextAutocorrectionTypeNo; // 关闭自动纠错
    textField.clearButtonMode = UITextFieldViewModeWhileEditing; // 清除按钮(编辑时出现)
    [cell.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(100 * kScaleFit);
        make.right.mas_equalTo(rightMargin);
    }];
    return textField;
}

@end
