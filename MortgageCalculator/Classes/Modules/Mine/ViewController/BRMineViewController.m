//
//  BRMineViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRMineViewController.h"
#import "BRLoginViewController.h"
#import "BRUserHelper.h"
#import "NSString+BRAdd.h"
#import <UIView+YYAdd.h>
#import "UIImage+BRAdd.h"
#import "BRFeedbackViewController.h"
#import "BRAboutUsViewController.h"

#define kHeaderH 200 * kScaleFit

@interface BRMineViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UIImageView *_headerImageView;
}
/** 头视图 */
@property (nonatomic, strong) UIImageView *headerImageView;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** 姓名 */
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *cacheLabel;

@property (nonatomic, strong) UIView *footerView;

// 自定义导航栏
@property (nonatomic, strong) UIImageView *navBgImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation BRMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏（注：这里要设置显示动画，防止返回时出现导航栏覆盖当前页面）
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadData {
    if ([NSString isBlankString:[BRUserHelper username]]) {
        self.nameLabel.userInteractionEnabled = YES;
        self.nameLabel.text = @"登录/注册";
        self.footerView.hidden = YES;
    } else {
        self.nameLabel.userInteractionEnabled = NO;
        self.nameLabel.text = [BRUserHelper username];
        self.footerView.hidden = NO;
    }
}

- (void)initUI {
    self.tableView.hidden = NO;
    [self setupHeaderView];
    [self setupNav];
}

/** 自定义导航栏 */
- (void)setupNav {
    // 背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, NAV_HEIGHT)];
    bgImageView.backgroundColor = [UIColor clearColor];
    bgImageView.image = [UIImage imageWithColor:RGB_HEX(0x4181e1, 1.0f)];
    [self.view addSubview:bgImageView];
    bgImageView.alpha = 0;
    self.navBgImageView = bgImageView;
    
    // 设置分割线
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale; // 一个像素点
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT - lineHeight, bgImageView.width, lineHeight)];
    lineView.backgroundColor = RGB_HEX(0XE3E3E3, 1.0);
    [bgImageView addSubview:lineView];
    
    // 导航栏标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUSBAR_HEIGHT);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    self.titleLabel = titleLabel;
}

/** 设置头视图 */
- (void)setupHeaderView {
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, kHeaderH)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    
    // 背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:_headView.bounds];
    bgImageView.backgroundColor = [UIColor clearColor];
    // 设置contentMode （等比例填充）
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 设置图像裁切（裁切外部的）
    _headerImageView.clipsToBounds = YES;
    bgImageView.image = [UIImage imageNamed:@"mine_head_bg"];
    [_headView addSubview:bgImageView];
    self.headerImageView = bgImageView;
    
    // 姓名 label
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = RGB_HEX(0x666666, 1.0f);
    nameLabel.text = @"登录/注册";
    [_headView addSubview:nameLabel];
    nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapNameLabel)];
    [nameLabel addGestureRecognizer:myTap];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.centerX.mas_equalTo(_headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200 * kScaleFit, 18 * kScaleFit));
    }];
    [nameLabel sizeToFit];
    self.nameLabel = nameLabel;
    
    // 头像
    UIImageView *avatarImageView = [[UIImageView alloc]init];
    avatarImageView.backgroundColor = [UIColor clearColor];
    avatarImageView.layer.cornerRadius = 36 * kScaleFit;
    avatarImageView.layer.borderWidth = 1.0f;
    avatarImageView.layer.borderColor = RGB_HEX(0xeeeeee, 1.0f).CGColor;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.image = [UIImage imageNamed:@"icon_default_avatar"];
    [_headView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(nameLabel.mas_top).with.offset(-20 * kScaleFit);
        make.centerX.mas_equalTo(bgImageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(72 * kScaleFit, 72 * kScaleFit));
    }];
    self.avatarImageView = avatarImageView;
    
}

- (void)didTapNameLabel {
    NSLog(@"登录/注册");
    BRLoginViewController *loginVC = [[BRLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 60 * kScaleFit)];
        _footerView.backgroundColor = [UIColor clearColor];
        // 退出登录按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithRed:180/255.0 green:45/255.0  blue:25/255.0 alpha:0.8];
        btn.layer.cornerRadius = 18;
        btn.titleLabel.font = [UIFont systemFontOfSize:17.0f * kScaleFit];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickLogOutBtn) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(_footerView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(_footerView.width * 2 / 3, 36));
        }];
    }
    return _footerView;
}

- (void)clickLogOutBtn {
    NSLog(@"退出登录");
    [MBProgressHUD showLoading:@"正在退出"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [BRUserHelper setUsername:@""];
        [BRUserHelper setPwd:@""];
        BRLoginViewController *loginVC = [[BRLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    });
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50 * kScaleFit;
        // 设置表格的间距(上，左，下，右)
        _tableView.contentInset = UIEdgeInsetsMake(kHeaderH, 0, 0, 0);
        _tableView.tableFooterView = self.footerView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    // 取消cell的选择效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.dataArr[indexPath.section][indexPath.row][0]];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    cell.textLabel.textColor = RGB_HEX(0x666666, 1.0);
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row][1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f * kScaleFit];
    cell.detailTextLabel.textColor = RGB_HEX(0x999999, 1.0);
    if (indexPath.section == 1 && indexPath.row == 2) {
        CGFloat size = [self folderSizeAtPath:DOCUMENT_PATH] + [self folderSizeAtPath:LIBRARY_PATH] + [self folderSizeAtPath:TEMP_PATH];
        cell.detailTextLabel.text = size > 1 ? [NSString stringWithFormat:@"%.2fM", size]:@"0.00M"; // [NSString stringWithFormat:@"%.2fK", size * 1024.0]
        _cacheLabel = cell.detailTextLabel;
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self pushShareView]; // 分享给朋友
        } else if (indexPath.row == 1) {
            [self pushFiveStar]; // 五星好评
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self pushCallService]; // 客服电话
        } else if (indexPath.row == 1) {
            [self pushFeedback]; // 意见反馈
        } else if (indexPath.row == 2) {
            [self clearCache]; // 清除缓存
        }
    } else {
        [self pushAboutUs]; // 关于我们
    }
}

//TODO:分享视图
- (void)pushShareView {
    //分享的标题
    NSString *textToShare = @"房贷计算器";
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"logo"];
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:APP_STORE_URL];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    // 指定隐藏的活动项目
    NSMutableArray *activityTypes = [NSMutableArray arrayWithArray:@[UIActivityTypeAirDrop, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo]];
    if (@available(iOS 9.0, *)) {
        [activityTypes addObject:UIActivityTypeOpenInIBooks];
    }
    if (@available(iOS 11.0, *)) {
        [activityTypes addObject:UIActivityTypeMarkupAsPDF];
    }
    activityVC.excludedActivityTypes = [activityTypes copy];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else  {
            NSLog(@"cancled");
            //分享 取消
            //UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"取消分享" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //[alertView show];
        }
    };
}

//TODO:五星好评
- (void)pushFiveStar {
    // 跳转到AppStore应用评价页
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APP_STORE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

//TODO:客服电话
- (void)pushCallService {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请咨询QQ客户:1032904627" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}

//TODO:意见反馈
- (void)pushFeedback {
    BRFeedbackViewController *feedbackVC = [[BRFeedbackViewController alloc]init];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

//TODO:清除缓存
- (void)clearCache {
    CGFloat size = [self folderSizeAtPath:DOCUMENT_PATH] + [self folderSizeAtPath:LIBRARY_PATH] + [self folderSizeAtPath:TEMP_PATH];
    if (size >= 1) {
        [self cleanCaches:DOCUMENT_PATH];
        [self cleanCaches:LIBRARY_PATH_CACHE];
        [self cleanCaches:TEMP_PATH];
        _cacheLabel.text = @"0.00M";
        [MBProgressHUD showSuccess:@"清除缓存成功"];
    } else {
        [MBProgressHUD showMessage:@"暂无可清理缓存"];
    }
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path {
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path {
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名 （取得一个目录下得所有文件名）
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            //......
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

//TODO:关于我们
- (void)pushAboutUs {
    BRAboutUsViewController *aboutUsVC = [[BRAboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12.0f * kScaleFit;
    }
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.0f * kScaleFit;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + kHeaderH;
    if (offsetY <= 0) {
        //NSLog(@"下拉放大：%f", offsetY);
        _headView.top = 0;
        _headView.height = kHeaderH - offsetY;
        _headerImageView.alpha = 1;
        self.navBgImageView.alpha = 0;
    } else if (offsetY > 0) {
        //NSLog(@"上滑整体移动");
        _headView.height = kHeaderH;
        
        // headerImageView 的最小高度
        CGFloat minHeight = kHeaderH - NAV_HEIGHT;
        _headView.top = -MIN(offsetY, minHeight);
        // 设置透明度
        CGFloat alpha = 1 - (offsetY / minHeight);
        _headerImageView.alpha = alpha;
        // 根据透明度来修改导航栏的颜色
        self.navBgImageView.alpha = 1 - alpha;
        if (self.navBgImageView.alpha > 0.5) {
            self.titleLabel.text = @"我的";
        } else {
            self.titleLabel.text = @"";
        }
    }
    // 设置图片的高度
    _headerImageView.height = _headView.height;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
                     @[@[@"mine_share.png", @"分享给朋友"], @[@"mine_comment.png", @"五星好评"]],
                     @[@[@"mine_service.png", @"咨询客服"], @[@"mine_feedback.png", @"意见反馈"], @[@"mine_cache.png", @"清除缓存"]], @[@[@"mine_about.png", @"关于我们"]]];
    }
    return _dataArr;
}

@end
