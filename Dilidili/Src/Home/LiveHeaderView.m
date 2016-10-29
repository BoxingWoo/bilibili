//
//  LiveHeaderView.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveHeaderView.h"
#import "BSCentralButton.h"

@implementation LiveHeaderView

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
        
        NSArray *buttonTitles = @[@"关注主播", @"直播中心", @"搜索房间", @"全部分类"];
        NSArray *buttonImages = @[@"live_home_follow_ico", @"live_home_center_ico", @"live_home_search_ico", @"live_home_category_ico"];
        UIStackView *buttonView = [[UIStackView alloc] init];
        buttonView.axis = UILayoutConstraintAxisHorizontal;
        buttonView.alignment = UIStackViewAlignmentCenter;
        buttonView.distribution = UIStackViewDistributionFillEqually;
        for (NSInteger i = 0; i < buttonTitles.count; i++) {
            BSCentralButton *button = [BSCentralButton buttonWithType:UIButtonTypeCustom andContentSpace:6.0];
            [button setImage:[UIImage imageNamed:buttonImages[i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:11];
            [button setTitleColor:kTextColor forState:UIControlStateNormal];
            [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
            button.tag = i;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                if (_actionSubject) {
                    [self.actionSubject sendNext:@(x.tag)];
                }
            }];
            [buttonView addArrangedSubview:button];
        }
        [self addSubview:buttonView];
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loopScrollView.mas_bottom).offset(30.0);
            make.bottom.equalTo(self.mas_bottom).offset(-22.0);
            make.left.equalTo(self.mas_left).offset(10.0);
            make.right.equalTo(self.mas_right).offset(-10.0);
        }];
    }
    return self;
}

@end
