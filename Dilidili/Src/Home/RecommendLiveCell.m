//
//  RecommendLiveCell.m
//  Dilidili
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendLiveCell.h"

@implementation RecommendLiveCell

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
        
        YYAnimatedImageView *faceImageView = [[YYAnimatedImageView alloc] init];
        _faceImageView = faceImageView;
//        faceImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:faceImageView];
        [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_left).offset(4.0);
            make.centerY.equalTo(coverImageView.mas_bottom);
            make.width.mas_equalTo(36.0);
            make.height.equalTo(faceImageView.mas_width);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = kTextColor;
        nameLabel.numberOfLines = 2;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(faceImageView.mas_right).offset(4.0);
            make.right.equalTo(coverImageView.mas_right);
            make.top.equalTo(coverImageView.mas_bottom).offset(6.0);
        }];
        
        UILabel *onlineLabel = [[UILabel alloc] init];
        _onlineLabel = onlineLabel;
        onlineLabel.backgroundColor = [UIColor colorWithWhite:228 / 255.0 alpha:1.0];
        onlineLabel.font = [UIFont systemFontOfSize:12];
        onlineLabel.textColor = kTextColor;
        onlineLabel.textAlignment = NSTextAlignmentCenter;
        onlineLabel.layer.cornerRadius = kCornerRadius;
        onlineLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:onlineLabel];
        [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_left);
            make.top.equalTo(nameLabel.mas_bottom).offset(4.0);
            make.width.mas_equalTo(40.0);
            make.height.mas_equalTo(16.0);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(onlineLabel.mas_right).offset(4.0);
            make.right.equalTo(coverImageView.mas_right);
            make.centerY.equalTo(onlineLabel.mas_centerY);
        }];
        
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn = refreshBtn;
        refreshBtn.hidden = YES;
        refreshBtn.adjustsImageWhenHighlighted = NO;
        refreshBtn.adjustsImageWhenDisabled = NO;
        [refreshBtn setImage:[UIImage imageNamed:@"home_refresh_new"] forState:UIControlStateNormal];
        [self.contentView addSubview:refreshBtn];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(6.0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(10.0);
            make.width.height.mas_equalTo(60.0);
        }];
    }
    return self;
}

@end
