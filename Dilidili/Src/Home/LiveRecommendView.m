//
//  LiveRecommendView.m
//  Dilidili
//
//  Created by iMac on 2016/10/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveRecommendView.h"

@implementation LiveRecommendView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *coverImageView = [[UIImageView alloc] init];
        _coverImageView = coverImageView;
        [self addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(coverImageView.mas_width).multipliedBy(0.625);
        }];
        
        YYAnimatedImageView *faceImageView = [[YYAnimatedImageView alloc] init];
        _faceImageView = faceImageView;
        [self addSubview:faceImageView];
        [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(4.0);
            make.centerY.equalTo(coverImageView.mas_bottom);
            make.width.height.mas_equalTo(30.0);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:11];
        nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-4.0);
            make.left.equalTo(faceImageView.mas_right).offset(4.0);
            make.top.equalTo(coverImageView.mas_bottom).offset(4.0);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textColor = [UIColor grayColor];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(4.0);
            make.right.equalTo(self.mas_right).offset(-4.0);
            make.top.equalTo(nameLabel.mas_bottom).offset(2.0);
        }];
        
        UILabel *onlineLabel = [[UILabel alloc] init];
        _onlineLabel = onlineLabel;
        onlineLabel.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:115 / 255.0 blue:152 / 255.0 alpha:0.8];
        onlineLabel.font = [UIFont systemFontOfSize:11];
        onlineLabel.textColor = [UIColor whiteColor];
        onlineLabel.textAlignment = NSTextAlignmentCenter;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 36, 14) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = path.CGPath;
        onlineLabel.layer.mask = mask;
        [self addSubview:onlineLabel];
        [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(coverImageView.mas_bottom).offset(-6.0);
            make.width.mas_equalTo(36.0);
            make.height.mas_equalTo(14.0);
        }];
    }
    return self;
}

@end
