//
//  VerticalButtonCell.m
//
//  Created by BoxingWoo on 15/8/15.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import "VerticalButtonCell.h"

@implementation VerticalButtonCell

- (instancetype)initWithTitleButton:(UIButton *)titleButton
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _titleButton = titleButton;
        [self.contentView addSubview:titleButton];
        for (NSInteger i = 0; i < 2; i++) {
            CALayer *separatedLine = [CALayer layer];
            if (i == 0) {
                _rightSeparatedLine = separatedLine;
            }else {
                _bottomSeparatedLine = separatedLine;
            }
            [self.contentView.layer addSublayer:separatedLine];
            separatedLine.backgroundColor = [UIColor colorWithWhite:203 / 255.0 alpha:1.0].CGColor;
        }
    }
    return self;
}

//重置布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    self.titleButton.frame = self.contentView.bounds;
    self.rightSeparatedLine.frame = CGRectMake(width - 0.5, 0, 0.5, height);
    self.bottomSeparatedLine.frame = CGRectMake(0, height - 0.5, width, 0.5);
}

@end
