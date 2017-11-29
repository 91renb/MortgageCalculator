//
//  BRNewsListCell.m
//  MortgageCalculator
//
//  Created by 任波 on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BRNewsListCell.h"
#import "BRNewsListModel.h"
#import "UIImageView+BRAdd.h"
#import "NSDate+BRAdd.h"

@interface BRNewsListCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation BRNewsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (void)setModel:(BRNewsListModel *)model {
    _model = model;
    [self.iconImageView br_setImageWithPath:[model.images lastObject] placeholder:@""];
    self.titleLabel.text = model.title;
    self.typeLabel.text = @"房贷计算器";
    self.dateLabel.text = [NSDate dateDescriptionWithTargetDate:model.date andTargetDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * kScaleFit);
        make.left.mas_equalTo(15 * kScaleFit);
        make.bottom.mas_equalTo(-15 * kScaleFit);
        make.width.mas_equalTo(94.0f * kScaleFit);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * kScaleFit);
        make.left.mas_equalTo(self.iconImageView.mas_right).with.offset(10 * kScaleFit);
        make.right.mas_equalTo(-15 * kScaleFit);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15 * kScaleFit);
        make.left.mas_equalTo(self.iconImageView.mas_right).with.offset(10 * kScaleFit);
        make.width.mas_equalTo(94.0f * kScaleFit);
        make.height.mas_equalTo(15.0f * kScaleFit);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15 * kScaleFit);
        make.right.mas_equalTo(-15 * kScaleFit);
        make.width.mas_equalTo(94.0f * kScaleFit);
        make.height.mas_equalTo(15.0f * kScaleFit);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f * kScaleFit];
        _titleLabel.textColor = RGB_HEX(0x333333, 1.0f);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.font = [UIFont systemFontOfSize:14.0f * kScaleFit];
        _typeLabel.textColor = RGB_HEX(0x999999, 1.0f);
    }
    return _typeLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:14.0f * kScaleFit];
        _dateLabel.textColor = RGB_HEX(0xc7c7c7, 1.0f);
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

#pragma mark - label富文本: 插入图片
- (NSMutableAttributedString *)setLabelText:(NSString *)text icon:(NSString *)iconName iconLocation:(NSInteger)location {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    // 文本附件
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:iconName];
    if (location == 0) {
        attch.bounds = CGRectMake(0, -4.0f * kScaleFit, 18.0f * kScaleFit, 18.0f * kScaleFit);
    } else {
        attch.bounds = CGRectMake(0, -2.0f * kScaleFit, 8.0f * kScaleFit, 14.0f * kScaleFit);
    }
    // 创建带有图片的富文本
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
    // 将图片插入指定位置
    [attrString insertAttributedString:imageStr atIndex:location];
    return attrString;
}

@end
