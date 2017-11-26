//
//  BRCalculateResultCell.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRCalculateResultCell.h"
#import "BRResultModel.h"

@interface BRCalculateResultCell ()
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *interestLabel;

@end

@implementation BRCalculateResultCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.totalPriceLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.interestLabel];
    }
    return self;
}

- (void)setMonthResultModel:(BRMonthResultModel *)monthResultModel {
    self.numberLabel.text = [NSString stringWithFormat:@"第 %@ 期", monthResultModel.number];
    self.totalPriceLabel.text = monthResultModel.monthRepayTotalPrice;
    self.priceLabel.text = monthResultModel.monthRepayPrice;
    self.interestLabel.text = monthResultModel.monthRepayInterest;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_left).with.offset(SCREEN_WIDTH / 8);
        make.height.mas_equalTo(20 * kScaleFit);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_left).with.offset(SCREEN_WIDTH / 8 + SCREEN_WIDTH / 4);
        make.height.mas_equalTo(20 * kScaleFit);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_left).with.offset(SCREEN_WIDTH / 8 + SCREEN_WIDTH * 2 / 4);
        make.height.mas_equalTo(20 * kScaleFit);
    }];
    [self.interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_left).with.offset(SCREEN_WIDTH / 8 + SCREEN_WIDTH * 3 / 4);
        make.height.mas_equalTo(20 * kScaleFit);
    }];
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
        _numberLabel.textColor = RGB_HEX(0x464646, 1.0f);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc]init];
        _totalPriceLabel.backgroundColor = [UIColor clearColor];
        _totalPriceLabel.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
        _totalPriceLabel.textColor = RGB_HEX(0x464646, 1.0f);
        _totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalPriceLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
        _priceLabel.textColor = RGB_HEX(0x464646, 1.0f);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (UILabel *)interestLabel {
    if (!_interestLabel) {
        _interestLabel = [[UILabel alloc]init];
        _interestLabel.backgroundColor = [UIColor clearColor];
        _interestLabel.font = [UIFont systemFontOfSize:12.0f * kScaleFit];
        _interestLabel.textColor = RGB_HEX(0x464646, 1.0f);
        _interestLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _interestLabel;
}

@end
