//
//  CategoryCell.m
//  Dilidili
//
//  Created by iMac on 2016/11/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_region_border"]];
        [self.contentView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(bgImageView.mas_width);
        }];
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        _iconImageView = iconImageView;
        [self.contentView addSubview:iconImageView];
        CGFloat width = widthEx(30.0);
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgImageView.mas_centerX);
            make.centerY.equalTo(bgImageView.mas_centerY);
            make.width.height.mas_equalTo(width);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = kTextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

@end
