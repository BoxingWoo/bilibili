//
//  BangumiListCell.m
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BangumiListCell.h"

@implementation BangumiListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *bangumiView = [[UIView alloc] init];
        bangumiView.backgroundColor = [UIColor whiteColor];
        bangumiView.layer.cornerRadius = kCornerRadius;
        bangumiView.layer.masksToBounds = YES;
        [self.contentView addSubview:bangumiView];
        [bangumiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIImageView *coverImageView = [[UIImageView alloc] init];
        _coverImageView = coverImageView;
        [bangumiView addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(bangumiView);
            make.height.equalTo(coverImageView.mas_width).multipliedBy(0.32);
        }];

        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = kTextColor;
        [bangumiView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_left).offset(10.0);
            make.right.equalTo(coverImageView.mas_right).offset(-10.0);
            make.top.equalTo(coverImageView.mas_bottom).offset(6.0);
        }];
        
        UILabel *descLabel = [[UILabel alloc] init];
        _descLabel = descLabel;
        descLabel.font = [UIFont systemFontOfSize:11];
        descLabel.textColor = [UIColor lightGrayColor];
        descLabel.numberOfLines = 0;
        [bangumiView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(8.0);
            make.bottom.equalTo(bangumiView.mas_bottom).offset(-10.0);
        }];
    }
    return self;
}

@end
