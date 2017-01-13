//
//  DdRefreshHeader.m
//  Dilidili
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdRefreshHeader.h"

@interface DdRefreshHeader ()

@property (nonatomic, strong) NSMutableArray *animateImages;

@end

@implementation DdRefreshHeader

- (void)prepare
{
    [super prepare];
    self.mj_h = 94.0;
    self.lastUpdatedTimeLabel.hidden = YES;
    [self setTitle:@"再拉，再拉就刷给你看" forState:MJRefreshStateIdle];
    [self setTitle:@"够了啦，松开人家嘛" forState:MJRefreshStatePulling];
    [self setTitle:@"刷呀刷呀，好累啊，喵^ω^" forState:MJRefreshStateRefreshing];
    [self setImages:@[self.animateImages.firstObject] forState:MJRefreshStateIdle];
    [self setImages:self.animateImages forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    CGFloat inset = 6.0;
    self.gifView.frame = CGRectMake(0, inset, self.mj_w, 59.0);
    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat stataLabelY = self.gifView.mj_y + self.gifView.mj_h + inset;
    self.stateLabel.frame = CGRectMake(0, stataLabelY, self.mj_w, self.mj_h -  stataLabelY - inset);
}

- (NSMutableArray *)animateImages
{
    if (!_animateImages) {
        _animateImages = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i <= 7; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"common_pull_loading_%li",i]];
            [_animateImages addObject:image];
        }
    }
    return _animateImages;
}

@end
