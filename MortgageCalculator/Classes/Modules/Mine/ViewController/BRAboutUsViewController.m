//
//  BRAboutUsViewController.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRAboutUsViewController.h"

@interface BRAboutUsViewController ()
@property (nonatomic , strong) UIImageView *logoImageView;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *versionLabel;
@property (nonatomic , strong) UILabel *copyrightLabel;

@end

@implementation BRAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"About Us", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI {
    self.logoImageView.hidden = NO;
    self.nameLabel.hidden = NO;
    self.versionLabel.hidden = NO;
    self.copyrightLabel.hidden = NO;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.backgroundColor = [UIColor clearColor];
        _logoImageView.image = [UIImage imageNamed:@"logo"];
        [self.view addSubview:_logoImageView];
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(NAV_HEIGHT + 50 * kScaleFit);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(80 * kScaleFit, 80 * kScaleFit));
        }];
    }
    return _logoImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
        _nameLabel.textColor = kTextDefaultColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = NSLocalizedString(@"房贷计算器", nil);
        [self.view addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.logoImageView.mas_bottom).with.offset(10 * kScaleFit);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200 * kScaleFit, 18 * kScaleFit));
        }];
    }
    return _nameLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.backgroundColor = [UIColor clearColor];
        _versionLabel.font = [UIFont systemFontOfSize:14.0f * kScaleFit];
        _versionLabel.textColor = RGB_HEX(0x999999, 1.0f);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.text = [NSString stringWithFormat:@"Version %@", APP_VERSION];
        [self.view addSubview:_versionLabel];
        [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).with.offset(5.0f * kScaleFit);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200 * kScaleFit, 15 * kScaleFit));
        }];
    }
    return _versionLabel;
}

- (UILabel *)copyrightLabel {
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc]init];
        _copyrightLabel.backgroundColor = [UIColor clearColor];
        _copyrightLabel.font = [UIFont systemFontOfSize:14.0f * kScaleFit];
        _copyrightLabel.textColor = RGB_HEX(0x999999, 1.0f);
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.text = @"Copyright ©2017 renbo";
        [self.view addSubview:_copyrightLabel];
        [_copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20.0f * kScaleFit);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(300 * kScaleFit, 15 * kScaleFit));
        }];
    }
    return _copyrightLabel;
}


@end
