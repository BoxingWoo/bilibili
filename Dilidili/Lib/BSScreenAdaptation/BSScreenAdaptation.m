//
//  BSScreenAdaptation.m
//
//  Created by mac on 16/7/30.
//  Copyright (c) 2016年 BoxingWoo. All rights reserved.
//

#import "BSScreenAdaptation.h"

@implementation BSScreenAdaptation

static CGFloat autoSizeScaleX = 1.0;  //宽度比
static CGFloat autoSizeScaleY = 1.0;  //高度比

+ (void)load;
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    autoSizeScaleX = size.width / DesignWidth;
    autoSizeScaleY = autoSizeScaleX;
}

#pragma mark 扩展函数适配Rect
CGRect CGRectMakeEx(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

#pragma mark 扩展函数适配Size
CGSize CGSizeMakeEx(CGFloat width, CGFloat height)
{
    CGSize size;
    size.width = autoSizeScaleX * width;
    size.height = autoSizeScaleY * height;
    return size;
}

#pragma mark 扩展函数适配Point
CGPoint CGPointMakeEx(CGFloat x, CGFloat y)
{
    CGPoint point;
    point.x = autoSizeScaleX * x;
    point.y = autoSizeScaleY * y;
    return point;
}

#pragma mark 拓展函数适配宽度
CGFloat widthEx(CGFloat width)
{
    return width * autoSizeScaleX;
}

#pragma mark 扩展函数适配高度
CGFloat heightEx(CGFloat height)
{
    return height * autoSizeScaleY;
}

@end
