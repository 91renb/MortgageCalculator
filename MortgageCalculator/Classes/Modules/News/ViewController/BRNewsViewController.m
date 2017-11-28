//
//  BRNewsViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRNewsViewController.h"
#import "UIScrollView+Refresh.h"
#import "BRNewsHandler.h"
#import "BRNewsListCell.h"
#import "BRNewsListModel.h"

@interface BRNewsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _pageOffset;
    NSInteger _pageSize;
}
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyDataView;
/** tableView 数据源数组 */
@property (nonatomic, strong) NSMutableArray *tableDataArr;

@end

@implementation BRNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资讯";
    [self initData];
    [self initUI];
    [self.tableView beginHeaderRefresh];
}

- (void)initData {
    _pageOffset = 0;
    _pageSize = 10;
}

- (void)initUI {
    self.tableView.hidden = NO;
}

#pragma mark - 请求资讯数据
- (void)loadData {
    [BRNewsHandler executeNewsListTaskWithPageOffset:_pageOffset pageSize:_pageSize Success:^(id obj) {
        NSLog(@"请求成功！");
        NSArray *resultModelArr = obj;
        if (_pageOffset == 0) {
            // 下拉刷新
            self.tableDataArr = [resultModelArr mutableCopy];
        } else {
            // 上拉加载更多
            [self.tableDataArr addObjectsFromArray:resultModelArr];
            if (!resultModelArr || resultModelArr.count == 0) {
                [self.tableView endFooterRefreshWithNoMoreData];
            }
        }
        [self.tableView reloadData];
        
        if (self.tableDataArr.count == 0) {
            [self addEmptyDataView];
        } else {
            [self removeEmptyDataViewFromSuperView];
        }
    } failed:^(id error) {
        
    }];
}

- (UIView *)addEmptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, (SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 40 - 100) / 2, 100, 100)];
        _emptyDataView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_emptyDataView];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 60, 51)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"empty_data"];
        [_emptyDataView addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 100, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = RGB_HEX(0x999999, 1.0f);
        label.text = @"暂无内容哦~";
        [_emptyDataView addSubview:label];
    }
    return _emptyDataView;
}

- (void)removeEmptyDataViewFromSuperView {
    if (self.emptyDataView != nil) {
        [self.emptyDataView removeFromSuperview];
    }
    self.emptyDataView = nil;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // iOS11之后要设置这两个属性，才会去掉默认的分区头部、尾部的高度
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        __weak typeof(self) weakSelf = self;
        __weak typeof(_tableView) weakTB = _tableView;
        // 添加下拉刷新
        [_tableView addHeaderRefresh:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _pageOffset = 0;
                [weakSelf loadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakTB endHeaderRefresh];
                });
            });
        }];
        // 添加上拉加载更多
        [_tableView addFooterRefresh:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                _pageOffset += 10;
                [weakSelf loadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakTB endFooterRefresh];
                });
            });
        }];
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
    static NSString *const cellID = @"newsListCell";
    BRNewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BRNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = self.tableDataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BRNewsListModel *model = self.tableDataArr[indexPath.row];
//    JBNewsDetailsViewController *newsDetailsVC = [[JBNewsDetailsViewController alloc]init];
//    newsDetailsVC.model = model;
//    newsDetailsVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:newsDetailsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f * kScaleFit;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

- (NSMutableArray *)tableDataArr {
    if (!_tableDataArr) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}

@end
