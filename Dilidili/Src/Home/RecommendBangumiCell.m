//
//  RecommendBangumiCell.m
//  Dilidili
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendBangumiCell.h"

@implementation RecommendBangumiCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *coverImageView = [[UIImageView alloc] init];
        _coverImageView = coverImageView;
//        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(coverImageView.mas_width).multipliedBy(0.63);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = kTextColor;
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(coverImageView);
            make.top.equalTo(coverImageView.mas_bottom).offset(4.0);
        }];
        
        UILabel *indexLabel = [[UILabel alloc] init];
        _indexLabel = indexLabel;
        indexLabel.font = [UIFont systemFontOfSize:12];
        indexLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_left).offset(4.0);
            make.right.equalTo(coverImageView.mas_right).offset(-4.0);
            make.bottom.equalTo(coverImageView.mas_bottom).offset(-4.0);
        }];
        
    }
    return self;
}

@end
