//
//  YPPlayerFPSLabel.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPPlayerFPSLabel.h"

#import "YYKit.h"

#define kSize CGSizeMake(68, 20)

@interface YPPlayerFPSLabel ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YPPlayerFPSLabel {
    UIFont *_font;
    UIFont *_subFont;
}

+ (instancetype)sharedFPSLabel
{
    static YPPlayerFPSLabel *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YPPlayerFPSLabel alloc] initWithFrame:CGRectMake(kScreenWidth - 5 - kSize.width, kScreenHeight - 68 - kSize.height, kSize.width, kSize.height)];
    });
    return _instance;
}

+ (void)showWithPlayer:(id<IJKMediaPlayback>)player
{
    [self dismiss];
    
    UIWindow *fpswindow = [UIApplication sharedApplication].windows.firstObject;
    YPPlayerFPSLabel *fpsLabel = [YPPlayerFPSLabel sharedFPSLabel];
    fpsLabel.player = player;
    if (fpsLabel.superview == nil) {
        [fpswindow addSubview:fpsLabel];
    }else {
        [fpswindow bringSubviewToFront:fpsLabel];
    }
    fpsLabel.timer = [NSTimer timerWithTimeInterval:1.0f target:[YYWeakProxy proxyWithTarget:fpsLabel] selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:fpsLabel.timer forMode:NSRunLoopCommonModes];
}

+ (void)dismiss
{
    YPPlayerFPSLabel *fpsLabel = [YPPlayerFPSLabel sharedFPSLabel];
    [fpsLabel removeFromSuperview];
    [fpsLabel.timer invalidate];
    fpsLabel.timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(NSTimer *)timer {
    CGFloat progress = self.player.fpsAtOutput;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d MVFPS",(int)round(progress)]];
    [text setColor:color range:NSMakeRange(0, text.length - 5)];
    [text setColor:[UIColor whiteColor] range:NSMakeRange(text.length - 5, 5)];
    text.font = _font;
    [text setFont:_subFont range:NSMakeRange(text.length - 6, 1)];
    
    self.attributedText = text;
}

@end
