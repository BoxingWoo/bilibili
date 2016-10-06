//
//  LiveFooterView.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveFooterView.h"

@implementation LiveFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn = allBtn;
        allBtn.backgroundColor = [UIColor whiteColor];
        allBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [allBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        [allBtn setTitle:@"全部直播" forState:UIControlStateNormal];
        allBtn.layer.cornerRadius = 6.0;
        allBtn.layer.borderWidth = 1.0;
        allBtn.layer.borderColor = kBorderColor.CGColor;
        [self addSubview:allBtn];
        [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 14, 10, 14));
        }];
    }
    return self;
}

@end
