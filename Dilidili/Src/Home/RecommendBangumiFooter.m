//
//  RecommendBangumiFooter.m
//  Dilidili
//
//  Created by iMac on 16/8/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendBangumiFooter.h"

@implementation RecommendBangumiFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = widthEx(144.0);
//        CGFloat height = heightEx(42.0);
        UIButton *timelineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timelineBtn = timelineBtn;
        timelineBtn.adjustsImageWhenHighlighted = NO;
        timelineBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [timelineBtn setImage:[UIImage imageNamed:@"home_bangumi_timeline"] forState:UIControlStateNormal];
        timelineBtn.layer.cornerRadius = 6.0;
        timelineBtn.layer.masksToBounds = YES;
        [self addSubview:timelineBtn];
        [timelineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10.0);
            make.top.equalTo(self.mas_top).offset(6.0);
            make.bottom.equalTo(self.mas_bottom).offset(-12.0);
            make.width.mas_equalTo(width);
        }];
        
        UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _categoryBtn = categoryBtn;
        categoryBtn.adjustsImageWhenHighlighted = NO;
        categoryBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [categoryBtn setImage:[UIImage imageNamed:@"home_bangumi_category"] forState:UIControlStateNormal];
        categoryBtn.layer.cornerRadius = 6.0;
        categoryBtn.layer.masksToBounds = YES;
        [self addSubview:categoryBtn];
        [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10.0);
            make.top.bottom.width.equalTo(timelineBtn);
        }];
    }
    return self;
}

@end
