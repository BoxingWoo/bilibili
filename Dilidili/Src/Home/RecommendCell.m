//
//  RecommendCell.m
//  Dilidili
//
//  Created by iMac on 16/8/27.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

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
        
        UIButton *playCount = [UIButton buttonWithType:UIButtonTypeCustom];
        _playCount = playCount;
        playCount.userInteractionEnabled = NO;
        playCount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        playCount.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        playCount.titleLabel.font = [UIFont systemFontOfSize:11];
        [playCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [playCount setImage:[UIImage imageNamed:@"misc_playCount_new"] forState:UIControlStateNormal];
        [self.contentView addSubview:playCount];
        [playCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_left).offset(6.0);
            make.bottom.equalTo(coverImageView.mas_bottom).offset(-4.0);
            make.width.equalTo(coverImageView.mas_width).dividedBy(2).offset(-4.0);
        }];
        
        UIButton *danmakuCount = [UIButton buttonWithType:UIButtonTypeCustom];
        _danmakuCount = danmakuCount;
        danmakuCount.userInteractionEnabled = NO;
        danmakuCount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        danmakuCount.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        danmakuCount.titleLabel.font = [UIFont systemFontOfSize:11];
        [danmakuCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [danmakuCount setImage:[UIImage imageNamed:@"misc_danmakuCount_new"] forState:UIControlStateNormal];
        [self.contentView addSubview:danmakuCount];
        [danmakuCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_centerX).offset(6.0);
            make.centerY.width.equalTo(playCount);
        }];
        
    }
    return self;
}

@end


@implementation RecommendRefreshCell

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
            make.bottom.equalTo(self.contentView.mas_bottom).offset(6.0);
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
