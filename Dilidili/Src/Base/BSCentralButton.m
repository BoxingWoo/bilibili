//
//  BSCentralButton.m
//  BSTabBarDemo
//
//  Created by BoxingWoo on 15/8/9.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import "BSCentralButton.h"

@implementation BSCentralButton

#pragma mark 类构造方法
+ (id)buttonWithType:(UIButtonType)buttonType andContentSpace:(CGFloat)space
{
    BSCentralButton *button = [self buttonWithType:buttonType];
    if (button) {
        button.contentSpace = space;
    }
    return button;
}

#pragma mark 实例构造方法
- (instancetype)initWithFrame:(CGRect)frame andContentSpace:(CGFloat)space target:(id)target action:(SEL)action
{
    self = [[self class] buttonWithType:UIButtonTypeCustom andContentSpace:space];
    if (self) {
        self.frame = frame;
        if (target && action) {
            [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

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

#pragma mark 通用初始化
- (void)commonInit
{
    _contentSpace = 3.0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.buttonType == UIButtonTypeCustom) {
        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
    }
}

#pragma mark 布局子视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image) {
        CGRect imageFrame = self.imageView.frame;
        CGRect titleFrame = self.titleLabel.frame;
        CGFloat topSpace = (self.frame.size.height - imageFrame.size.height - titleFrame.size.height - self.contentSpace) / 2;
        
        imageFrame.origin.x = (self.frame.size.width - imageFrame.size.width) / 2;
        imageFrame.origin.y = topSpace;
        self.imageView.frame = imageFrame;

        titleFrame.origin.x = 0;
        titleFrame.origin.y = topSpace + imageFrame.size.height + self.contentSpace;
        titleFrame.size.width = self.frame.size.width;
        self.titleLabel.frame = titleFrame;
    }
}

@end
