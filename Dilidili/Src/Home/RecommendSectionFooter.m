//
//  RecommendSectionFooter.m
//  Dilidili
//
//  Created by iMac on 16/8/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendSectionFooter.h"

@implementation RecommendSectionFooter

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
        [loopScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

@end
