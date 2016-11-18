//
//  BangumiHeaderView.m
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BangumiHeaderView.h"
#import "BSCentralButton.h"

@implementation BangumiHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        BSLoopScrollView *loopScrollView = [[BSLoopScrollView alloc] init];
        _loopScrollView = loopScrollView;
        loopScrollView.autoScrollDuration = 5.0;
        loopScrollView.pageControlPosition = BSPageControlPositionRight;
        loopScrollView.currentPageIndicatorTintColor = kThemeColor;
        loopScrollView.pageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:loopScrollView];
        [loopScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(loopScrollView.mas_width).multipliedBy(0.3);
        }];
        
        NSArray *categoryTitles = @[@"连载动画", @"完结动画", @"国产动画", @"官方延伸"];
        NSArray *categoryImages = @[@"home_region_icon_33", @"home_region_icon_32", @"home_region_icon_153", @"home_region_icon_152"];
        UIStackView *categoryView = [[UIStackView alloc] init];
        categoryView.axis = UILayoutConstraintAxisHorizontal;
        categoryView.alignment = UIStackViewAlignmentFill;
        categoryView.distribution = UIStackViewDistributionFillEqually;
        for (NSInteger i = 0; i < categoryTitles.count; i++) {
            BSCentralButton *button = [BSCentralButton buttonWithType:UIButtonTypeCustom andContentSpace:4.0];
            [button setImage:[UIImage imageNamed:categoryImages[i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            [button setTitleColor:kTextColor forState:UIControlStateNormal];
            [button setTitle:categoryTitles[i] forState:UIControlStateNormal];
            button.tag = i;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                if (_categorySubject) {
                    [self.categorySubject sendNext:@(x.tag)];
                }
            }];
            [categoryView addArrangedSubview:button];
        }
        [self addSubview:categoryView];
        [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loopScrollView.mas_bottom).offset(18.0);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(48.0);
        }];
        
        NSArray *optionTitles = @[@"追番", @"放送表", @"索引"];
        NSArray *optionImages = @[@"home_bangumi_tableHead_followIcon",  @"home_bangumi_tableHead_week6", @"home_bangumi_tableHead_indexIcon"];
        NSArray *optionBgColors = @[RGBA(253, 166, 9, 1), RGBA(252, 86, 92, 1), RGBA(78, 175, 255, 1)];
        UIStackView *optionView = [[UIStackView alloc] init];
        optionView.axis = UILayoutConstraintAxisHorizontal;
        optionView.alignment = UIStackViewAlignmentFill;
        optionView.distribution = UIStackViewDistributionFillEqually;
        optionView.spacing = 10.0;
        for (NSInteger i = 0; i < optionTitles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 6.0;
            button.backgroundColor = optionBgColors[i];
            button.adjustsImageWhenHighlighted = NO;
            [button setImage:[UIImage imageNamed:optionImages[i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:optionTitles[i] forState:UIControlStateNormal];
            button.tag = i;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                if (_optionSubject) {
                    [self.optionSubject sendNext:@(x.tag)];
                }
            }];
            [optionView addArrangedSubview:button];
        }
        [self addSubview:optionView];
        [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(categoryView.mas_bottom).offset(16.0);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left).offset(10.0);
            make.right.equalTo(self.mas_right).offset(-10.0);
        }];
    }
    return self;
}

@end
