//
//  BRLanguageViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/12/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRLanguageViewController.h"
#import "NSBundle+Language.h"
#import "BRTabBarController.h"

@interface BRLanguageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSIndexPath *lastIndexPath; // 用来记录tableviewcell选中位置
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableDataArr;

@end

@implementation BRLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"设置语言", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(clickDone)];
    [self initUI];
}

- (void)clickDone {
    NSDictionary *dic = [self.tableDataArr objectAtIndex:lastIndexPath.row];
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"];
    if ([dic[@"language"] isEqualToString:currentLanguage]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [MBProgressHUD showLoading:NSLocalizedString(@"正在设置语言 ...", nil)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [self changeLanguageTo:dic[@"language"]]; // 切换语言
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initUI {
    self.tableView.hidden = NO;
}

- (void)changeLanguageTo:(NSString *)language {
    // 设置语言
    [NSBundle setLanguage:language];
    
    // 然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"myLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 我们要把系统windown的rootViewController替换掉
    BRTabBarController *tabarVC = [[BRTabBarController alloc] initWithDefaultSelIndex:2];
    tabarVC.selectedIndex = 2;
    self.view.window.rootViewController = tabarVC;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // iOS11之后要设置这两个属性，才会去掉默认的分区头部、尾部的高度
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellID = @"languageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    cell.textLabel.textColor = kTextDefaultColor;
    NSDictionary *dic = [self.tableDataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = dic[@"name"];
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguage"];
    if ([dic[@"language"] isEqualToString:currentLanguage]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastIndexPath = indexPath;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 获取点击/选中的cell
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    // 有默认选中，点击新的选中
    if (lastIndexPath != nil && lastIndexPath != indexPath) {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    // 点击后执行的操作
    NSLog(@"选中了第%zi行", indexPath.row);
    lastIndexPath = indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (NSArray *)tableDataArr {
    if (!_tableDataArr) {
        _tableDataArr = @[@{@"name": @"中文简体", @"language": @"zh-Hans"},
                          @{@"name": @"中文繁體", @"language": @"zh-Hant"},
                          @{@"name": @"English", @"language": @"en"},
                          @{@"name": @"한국어", @"language": @"ko"},
                          @{@"name": @"日本语", @"language": @"ja"},
                          @{@"name": @"Pусский", @"language": @"ru"},
                          @{@"name": @"Español", @"language": @"es"},
                          @{@"name": @"Français", @"language": @"fr"}
                      ];
    }
    return _tableDataArr;
}

@end
