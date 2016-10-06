//
//  LiveCell.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveCell.h"

@implementation LiveCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *coverImageView = [[UIImageView alloc] init];
        _coverImageView = coverImageView;
        [self.contentView addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(coverImageView.mas_width).multipliedBy(0.639);
        }];
        
        UIButton *onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _onlineBtn = onlineBtn;
        onlineBtn.userInteractionEnabled = NO;
        onlineBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        onlineBtn.tintColor = [UIColor whiteColor];
        UIImage *onlineImage = [[UIImage imageNamed:@"live_eye_ico"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [onlineBtn setImage:onlineImage forState:UIControlStateNormal];
        onlineBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [onlineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:onlineBtn];
        [onlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(coverImageView.mas_right).offset(-4.0);
            make.bottom.equalTo(coverImageView.mas_bottom).offset(-4.0);
            make.width.mas_equalTo(60.0);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:11];
        nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_left).offset(4.0);
            make.right.equalTo(onlineBtn.mas_left).offset(-4.0);
            make.centerY.equalTo(onlineBtn.mas_centerY);
        }];
        [nameLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = kTextColor;
        titleLabel.numberOfLines = 2;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(coverImageView);
            make.top.equalTo(coverImageView.mas_bottom).offset(4.0);
        }];
    }
    return self;
}

@end


@implementation LiveRefreshCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn = refreshBtn;
        refreshBtn.adjustsImageWhenHighlighted = NO;
        refreshBtn.adjustsImageWhenDisabled = NO;
        [refreshBtn setImage:[UIImage imageNamed:@"home_refresh_new"] forState:UIControlStateNormal];
        [self.contentView addSubview:refreshBtn];
        [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(6.0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(10.0);
            make.width.height.mas_equalTo(60.0);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImageView.mas_left);
            make.right.equalTo(refreshBtn.mas_left);
            make.top.equalTo(self.coverImageView.mas_bottom).offset(4.0);
        }];
        [self.titleLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
        [self.titleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

@end
