//
//  LiveCenterSectionHeader.m
//  Dilidili
//
//  Created by iMac on 2016/10/28.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveCenterSectionHeader.h"

@implementation LiveCenterSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = kTextColor;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(16.0);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.userInteractionEnabled = NO;
        line.backgroundColor = kBorderColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

@end
