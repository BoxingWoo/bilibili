//
//  RecommendSectionHeader.m
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendSectionHeader.h"

@implementation RecommendSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconImageView = [[UIImageView alloc] init];
        _iconImageView = iconImageView;
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0);
            make.top.equalTo(self.mas_top).offset(10.0);
            make.bottom.equalTo(self.mas_bottom).offset(-4.0);
            make.width.mas_equalTo(20.0);
            make.height.equalTo(iconImageView.mas_width);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        titleLabel.textColor = kTextColor;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).offset(4.0);
            make.centerY.equalTo(iconImageView.mas_centerY);
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        _arrowImageView = arrowImageView;
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10.0);
            make.centerY.equalTo(iconImageView.mas_centerY);
        }];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn = moreBtn;
        moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        moreBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-6.0);
            make.left.greaterThanOrEqualTo(titleLabel.mas_right).offset(8.0);
            make.centerY.equalTo(iconImageView.mas_centerY);
            make.height.equalTo(iconImageView.mas_height);
        }];
        [moreBtn setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        [moreBtn setContentHuggingPriority:252 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

@end



@implementation RecommendBannerSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        BSLoopScrollView *loopScrollView = [[BSLoopScrollView alloc] initWithFrame:CGRectZero];
        _loopScrollView = loopScrollView;
        loopScrollView.autoScrollDuration = 5.0;
        loopScrollView.pageControlPosition = BSPageControlPositionRight;
        loopScrollView.pageIndicatorTintColor = [UIColor whiteColor];
        loopScrollView.currentPageIndicatorTintColor = kThemeColor;
        [self addSubview:loopScrollView];
        CGFloat loopScrollViewHeight = heightEx(96.0);
        [loopScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(loopScrollViewHeight);
        }];
        
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0);
            make.top.equalTo(loopScrollView.mas_bottom).offset(18.0);
            make.bottom.equalTo(self.mas_bottom).offset(-4.0);
            make.width.mas_equalTo(20.0);
            make.height.equalTo(self.iconImageView.mas_width);
        }];
    }
    return self;
}

@end

