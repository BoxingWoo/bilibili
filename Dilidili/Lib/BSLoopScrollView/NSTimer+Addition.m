//
//  NSTimer+Addition.m
//  WBSLoopScrollViewDemo
//
//  Created by BoxingWoo on 15/10/28.
//  Copyright © 2015年 BoxingWoo. All rights reserved.
//

#import "NSTimer+Addition.h"
#import <objc/runtime.h>

@implementation NSTimer (Addition)

//是否暂停
- (BOOL)isPause
{
    NSNumber *isPause = objc_getAssociatedObject(self, _cmd);
    if (!isPause) {
        objc_setAssociatedObject(self, _cmd, @0, OBJC_ASSOCIATION_ASSIGN);
    }
    return [isPause boolValue];
}

//暂停计时
- (void)pause
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
    objc_setAssociatedObject(self, @selector(isPause), @1, OBJC_ASSOCIATION_ASSIGN);
}

//继续计时
- (void)resume
{
    [self resumeAfterTimeInterval:0];
}

//一定时间后继续计时
- (void)resumeAfterTimeInterval:(NSTimeInterval)timeInterval
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
    objc_setAssociatedObject(self, @selector(isPause), @0, OBJC_ASSOCIATION_ASSIGN);
}

@end
