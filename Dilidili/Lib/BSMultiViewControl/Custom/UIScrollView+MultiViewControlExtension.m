//
//  UIScrollView+MultiViewControlExtension.m
//
//  Created by BoxingWoo on 15-7-23.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import "UIScrollView+MultiViewControlExtension.h"
#import <objc/runtime.h>

@implementation UIScrollView (MultiViewControlExtension)

- (void)setSynScrollContentViews:(NSArray *)synScrollContentViews
{
    objc_setAssociatedObject(self, @selector(synScrollContentViews), synScrollContentViews, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)synScrollContentViews
{
    return objc_getAssociatedObject(self, _cmd);
}

//居中式同步滑动方法
- (void)centerSynScrollByIndexOfSubview:(NSInteger)index andPageSize:(NSInteger)pageSize
{
    if (index >= self.synScrollContentViews.count) {
        return;
    }
    NSUInteger count = self.synScrollContentViews.count;
    NSInteger offsetCenter = pageSize / 2 + 1;
    CGFloat offset;
    if (index < offsetCenter) {
        offset = 0;
    }else if (index + (pageSize - offsetCenter) > count - 1) {
        offset = (count - (pageSize - offsetCenter) - offsetCenter) * (self.frame.size.width / pageSize);
    }else {
        offset = (index + 1 - offsetCenter) * (self.frame.size.width / pageSize);
    }
    [self setContentOffset:CGPointMake(offset, 0) animated:YES];
}

//两边式同步滑动方法
- (void)edgeSynScrollByIndexOfSubview:(NSInteger)index andItemSpace:(CGFloat)itemSpace
{
    if (index >= self.synScrollContentViews.count) {
        return;
    }
    CGFloat distance = 0;
    CGFloat x = self.contentOffset.x;
    CGFloat width = self.frame.size.width;
    UIView *nextView = nil;
    if (index + 1 < self.synScrollContentViews.count) {
        nextView = self.synScrollContentViews[index + 1];
    }
    UIView *previousView = nil;
    if (index - 1 >= 0) {
        previousView = self.synScrollContentViews[index - 1];
    }
    if (nextView) {
        distance = nextView.frame.origin.x + nextView.frame.size.width + itemSpace - x;
        if (distance >= width) {
            CGFloat contentOffsetX = x + distance - width < self.contentSize.width - self.frame.size.width ? x + distance - width : self.contentSize.width - self.frame.size.width;
            [self setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
        }
    }else {
        [self setContentOffset:CGPointMake(self.contentSize.width - self.frame.size.width, 0) animated:YES];
    }
    
    if (previousView) {
        distance = previousView.frame.origin.x - x;
        if (distance <= 0) {
            CGFloat contentOffsetX = x + distance - itemSpace > 0 ? x + distance - itemSpace : 0;
            [self setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
        }
    }else {
        [self setContentOffset:CGPointZero animated:YES];
    }
}

@end
