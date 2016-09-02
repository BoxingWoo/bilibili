//
//  NSTimer+Addition.h
//  WBSLoopScrollViewDemo
//
//  Created by BoxingWoo on 15/10/28.
//  Copyright © 2015年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

//是否暂停
@property (nonatomic, assign, readonly) BOOL isPause;

//暂停计时
- (void)pause;

//继续计时
- (void)resume;

//一定时间后继续计时
- (void)resumeAfterTimeInterval:(NSTimeInterval)timeInterval;

@end
