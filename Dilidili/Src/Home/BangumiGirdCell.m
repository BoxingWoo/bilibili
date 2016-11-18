//
//  BangumiGirdCell.m
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BangumiGirdCell.h"

@implementation BangumiGirdCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *coverImageView = [[UIImageView alloc] init];
        _coverImageView = coverImageView;
        [self.contentView addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(coverImageView.mas_width).multipliedBy(1.33);
        }];
        
        UILabel *onlineLabel = [[UILabel alloc] init];
        _onlineLabel = onlineLabel;
        onlineLabel.font = [UIFont systemFontOfSize:11];
        onlineLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:onlineLabel];
        [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_right).offset(4.0);
            make.right.equalTo(coverImageView.mas_right).offset(-4.0);
            make.bottom.equalTo(coverImageView.mas_bottom).offset(-4.0);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = kTextColor;
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(coverImageView);
            make.top.equalTo(coverImageView.mas_bottom).offset(8.0);
        }];
        
        UILabel *indexLabel = [[UILabel alloc] init];
        _indexLabel = indexLabel;
        indexLabel.font = [UIFont systemFontOfSize:11];
        indexLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).offset(6.0);
        }];
    }
    return self;
}

@end
