//
//  BangumiSectionHeader.m
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BangumiSectionHeader.h"

@implementation BangumiSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconImageView = [[UIImageView alloc] init];
        _iconImageView = iconImageView;
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.mas_equalTo(20.0);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = kTextColor;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(4.0);
            make.centerY.equalTo(iconImageView.mas_centerY);
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_rightArrowShadow"]];
        _arrowImageView = arrowImageView;
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10.0);
            make.centerY.equalTo(iconImageView.mas_centerY);
        }];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn = moreBtn;
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-6.0);
            make.centerY.equalTo(iconImageView.mas_centerY);
        }];
    }
    return self;
}

@end
