//
//  RecommendScrollCell.m
//  Dilidili
//
//  Created by iMac on 16/8/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendScrollCell.h"

@implementation RecommendScrollContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *coverImageView = [[UIImageView alloc] init];
        _coverImageView = coverImageView;
//        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(coverImageView.mas_width).multipliedBy(0.57);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = kTextColor;
        titleLabel.numberOfLines = 2;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(coverImageView);
            make.top.equalTo(coverImageView.mas_bottom).offset(4.0);
        }];
    }
    return self;
}

@end



@implementation RecommendScrollCell
{
    NSMutableDictionary *_contentDict;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _contentDict = [NSMutableDictionary dictionary];
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentInset = UIEdgeInsetsMake(4, 0, 4, 10);
        [self.contentView addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (RecommendScrollContentView *)dequeueReusableContentViewforIndex:(NSUInteger)index
{
    RecommendScrollContentView *contentView = [_contentDict objectForKey:@(index)];
    if (contentView == nil) {
        contentView = [[RecommendScrollContentView alloc] initWithFrame:CGRectMake(0, 0, widthEx(158.0), heightEx(90.0) + 42.0)];
        [_contentDict setObject:contentView forKey:@(index)];
    }
    return contentView;
}

- (void)setContentViews:(NSArray *)contentViews
{
    NSInteger delta = (NSInteger)contentViews.count - _contentViews.count;
    CGFloat width = widthEx(158.0);
    CGFloat inset = 10.0;
    if (delta > 0) {
        for (NSInteger i = 0; i < delta; i++) {
            RecommendScrollContentView *contentView = contentViews[_contentViews.count + i];
            contentView.left = (_contentViews.count + i) * width + (_contentViews.count + i + 1) * inset;
            [self.scrollView addSubview:contentView];
        }
    }else if (delta < 0) {
        for (NSInteger i = 0; i > delta; i--) {
            RecommendScrollContentView *contentView = _contentViews[contentViews.count - i];
            [contentView removeFromSuperview];
        }
    }
    self.scrollView.contentSize = CGSizeMake((width + inset) * contentViews.count, 0);
    _contentViews = contentViews;
}

@end
