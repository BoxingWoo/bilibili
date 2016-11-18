//
//  BSLoopScrollView.m
//  BSLoopScrollViewDemo
//
//  Created by BoxingWoo on 15/10/28.
//  Copyright © 2015年 BoxingWoo. All rights reserved.
//

#import "BSLoopScrollView.h"
#import "NSTimer+Addition.h"

#pragma mark - 循环滚动视图
@interface BSLoopScrollView () <UIScrollViewDelegate>

/** 滚动视图 */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 页面控制 */
@property (nonatomic, weak) UIPageControl *pageControl;
/** 触摸手势 */
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRecognizer;
/** 第一个子视图 */
@property (nonatomic, weak) UIView *firstView;
/** 最后一个子视图 */
@property (nonatomic, weak) UIView *lastView;
/** 页数 */
@property (nonatomic, assign) NSUInteger pageCount;
/** 当前页 */
@property (nonatomic, assign) NSInteger currentPage;
/** 定时器 */
@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end

@implementation BSLoopScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    [self.autoScrollTimer invalidate];
}

#pragma mark 通用初始化
- (void)commonInit
{
    _pageControlPosition = BSPageControlPositionNone;
    _pageIndicatorTintColor = [UIColor colorWithWhite:225 / 255.0 alpha:0.8];
    _currentPageIndicatorTintColor = [UIColor whiteColor];
    _shouldAllowTouch = YES;
    _autoScrollDuration = 0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView = scrollView;
    [self addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeZero;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    _tapGestureRecognizer = tapGestureRecognizer;
    [scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark 布局子视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 布局内容视图
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    for (int i = 0; i < _pageCount; i++) {
        UIView *contentView = self.contentViews[i];
        contentView.frame = CGRectMake((i + 1) * width, 0, width, height);
    }
    
    if (_pageCount) {
        self.scrollView.contentSize = CGSizeMake((_pageCount + 2) * width, height);
        [self.scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
    }
}

#pragma mark 刷新视图
- (void)reloadData
{
    if (self.dataSource == nil) {
        return;
    }
    
    _contentViews = nil;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.autoScrollTimer invalidate];
    _pageCount = [self.dataSource numberOfItemsInLoopScrollView:self];
    _currentPage = 0;
    
    self.tapGestureRecognizer.enabled = _shouldAllowTouch;
    
    // 页面控制
    if (_pageControlPosition != BSPageControlPositionNone) {
        self.pageControl.numberOfPages = _pageCount;
        self.pageControl.currentPage = _currentPage;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
        self.pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    }else {
        [_pageControl removeFromSuperview];
    }
    
    // 添加内容视图
    NSMutableArray *contentViews = [[NSMutableArray alloc] initWithCapacity:_pageCount];
    for (int i = 0; i < _pageCount; i++) {
        UIView *contentView = [self.dataSource loopScrollView:self contentViewAtIndex:i];
        if (!contentView) {
            NSAssert(NO, @"ContentView can not be nil");
        }
        
        contentView.clipsToBounds = YES;
        if (i == 0) {
            _firstView = contentView;
        }else if (i == _pageCount - 1) {
            _lastView = contentView;
        }
        [contentViews addObject:contentView];
        [self.scrollView addSubview:contentView];
    }
    _contentViews = contentViews;
    [self setNeedsLayout];
    
    // 手动滚动
    if (_pageCount > 1) {
        self.scrollView.scrollEnabled = YES;
    }else {
        self.scrollView.scrollEnabled = NO;
    }
    
    // 自动循环滚动
    if (_pageCount > 1 && _autoScrollDuration > 0) {
        self.autoScrollTimer = [NSTimer timerWithTimeInterval:_autoScrollDuration target:self selector:@selector(handleAutoScroll:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.autoScrollTimer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark 懒加载pageControl
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl = pageControl;
        [self addSubview:pageControl];
        pageControl.hidesForSinglePage = YES;
        [pageControl addTarget:self action:@selector(handlePageControlAction:) forControlEvents:UIControlEventValueChanged];
        
        CGFloat margin = 12.0;
        pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        if (_pageControlPosition == BSPageControlPositionLeft) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[pageControl]" options:0 metrics:@{@"margin":@(margin)} views:NSDictionaryOfVariableBindings(pageControl)]];
        }else if (_pageControlPosition == BSPageControlPositionRight) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pageControl]-margin-|" options:0 metrics:@{@"margin":@(margin)} views:NSDictionaryOfVariableBindings(pageControl)]];
        }else if (_pageControlPosition == BSPageControlPositionMiddle) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageControl]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(pageControl)]];
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-margin-|" options:0 metrics:@{@"margin":@(-8)} views:NSDictionaryOfVariableBindings(pageControl)]];
    }
    return _pageControl;
}

#pragma mark 自动循环滚动
- (void)handleAutoScroll:(NSTimer *)timer
{
    _currentPage = (_currentPage + 2) % (_pageCount + 2);
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    CGPoint contentOffset = CGPointMake(_currentPage * width, 0);
    if (contentOffset.x < width) {
        self.lastView.frame = CGRectMake(0, 0, width, height);
    }else if (contentOffset.x > _pageCount * width) {
        self.firstView.frame = CGRectMake((_pageCount + 1) * width, 0, width, height);
    }
    [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
        [self.scrollView setContentOffset:contentOffset];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndScrollingAnimation:self.scrollView];
    }];
}

#pragma mark 页面控制响应事件
- (void)handlePageControlAction:(UIPageControl *)pageControl
{
    [self.autoScrollTimer pause];
    _currentPage = pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake((_currentPage + 1) * self.scrollView.bounds.size.width, 0) animated:YES];
}

#pragma mark 点击滚动内容视图响应事件
- (void)handleTapAction:(UITapGestureRecognizer *)tap
{
    NSInteger index = [tap locationInView:tap.view].x / tap.view.bounds.size.width - 1;
    if (index < self.contentViews.count) {
        UIView *contentView = self.contentViews[index];
        if ([self.delegate respondsToSelector:@selector(loopScrollView:didTouchContentView:atIndex:)]) {
            [self.delegate loopScrollView:self didTouchContentView:contentView atIndex:index];
        }
    }
}

#pragma mark 重置内容视图位置
- (void)resetPosition
{
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    self.firstView.frame = CGRectMake(width, 0, width, height);
    self.lastView.frame = CGRectMake(_pageCount * width, 0, width, height);
    if (self.scrollView.contentOffset.x == (_pageCount + 1) * width) {
        [self.scrollView scrollRectToVisible:self.firstView.frame animated:NO];
    }else if (self.scrollView.contentOffset.x == 0) {
        [self.scrollView scrollRectToVisible:self.lastView.frame animated:NO];
    }
    _currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width - 1;
    _pageControl.currentPage = _currentPage;
}

#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(scrollView.bounds);
    CGFloat height = CGRectGetHeight(scrollView.bounds);
    if (_pageCount == 2) {
        if (scrollView.contentOffset.x < width) {
            self.lastView.frame = CGRectMake(0, 0, width, height);
        }else {
            self.lastView.frame = CGRectMake(_pageCount * width, 0, width, height);
        }
        if (scrollView.contentOffset.x > _pageCount * width) {
            self.firstView.frame = CGRectMake((_pageCount + 1) * width, 0, width, height);
        }else {
            self.firstView.frame = CGRectMake(width, 0, width, height);
        }
    }else {
        if (scrollView.contentOffset.x < width) {
            self.lastView.frame = CGRectMake(0, 0, width, height);
        }else if (scrollView.contentOffset.x > _pageCount * width) {
            self.firstView.frame = CGRectMake((_pageCount + 1) * width, 0, width, height);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.autoScrollTimer pause];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.autoScrollTimer resumeAfterTimeInterval:_autoScrollDuration];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetPosition];
    if ([self.delegate respondsToSelector:@selector(loopScrollViewDidEndDecelerating:atIndex:)]) {
        [self.delegate loopScrollViewDidEndDecelerating:self atIndex:_currentPage];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetPosition];
    if (self.autoScrollTimer.isPause) {
        [self.autoScrollTimer resumeAfterTimeInterval:_autoScrollDuration];
    }
}

@end
