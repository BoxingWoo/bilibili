//
//  DdRefreshActivityIndicatorFooter.m
//  Dilidili
//
//  Created by iMac on 16/9/18.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdRefreshActivityIndicatorFooter.h"

@interface DdRefreshActivityIndicatorFooter ()

@property (nonatomic, weak) UIActivityIndicatorView *loading;

@end

@implementation DdRefreshActivityIndicatorFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.automaticallyHidden = YES;
    
    //loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loading = loading;
    loading.hidesWhenStopped = NO;
    [self addSubview:loading];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.loading.center = CGPointMake(self.mj_w / 2, self.mj_h / 2);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    if (self.scrollView.mj_contentH < self.scrollView.mj_h) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
        default:
            break;
    }
}

@end
