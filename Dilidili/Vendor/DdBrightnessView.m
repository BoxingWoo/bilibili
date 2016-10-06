//
//  DdBrightnessView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/23.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "DdBrightnessView.h"

@interface DdBrightnessView ()

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *longView;
@property (nonatomic, strong) NSMutableArray *tipArray;
@property (nonatomic, assign) BOOL orientationDidChange;

@end

@implementation DdBrightnessView

+ (void)load
{
    [self sharedBrightnessView];
}

+ (instancetype)sharedBrightnessView {
    static DdBrightnessView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    });
    return instance;
}

+ (void)show
{
    [self hide:NO];
    DdBrightnessView *brightnessView = [self sharedBrightnessView];
    [brightnessView appear];
}

+ (void)hide:(BOOL)animate
{
    DdBrightnessView *brightnessView = [self sharedBrightnessView];
    if (!brightnessView.superview) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:brightnessView selector:@selector(disappearAndFade) object:nil];
    if (animate) {
        [brightnessView disappearAndFade];
    }else {
        brightnessView.alpha = 0.0;
        [brightnessView removeFromSuperview];
    }
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect
{
    if (self = [super initWithEffect:effect]) {
        self.frame = CGRectMake(kScreenWidth * 0.5, kScreenHeight * 0.5, 155, 155);
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        
        self.backImage = ({
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
            imgView.image = [UIImage imageNamed:@"brightness_icon"];
            [self.contentView addSubview:imgView];
            imgView;
        });
        
        self.title = ({
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.width, 30)];
            title.font = [UIFont boldSystemFontOfSize:16];
            title.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
            title.textAlignment = NSTextAlignmentCenter;
            title.text = @"亮度";
            [self.contentView addSubview:title];
            title;
        });
        
        self.longView = ({
            UIView *longView = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.width - 26, 7)];
            longView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
            [self.contentView addSubview:longView];
            longView;
        });
    
        [self createTips];
        [self addNotification];
        [self addObserver];
        
        self.alpha = 0.0;
    }
    return self;
}

- (void)createTips {
    
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    
    CGFloat tipW = (self.longView.bounds.size.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX = i * (tipW + 1) + 1;
        UIImageView *image = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame = CGRectMake(tipX, tipY, tipW, tipH);
        [self.longView addSubview:image];
        [self.tipArray addObject:image];
    }
    [self updateLongView:[UIScreen mainScreen].brightness];
}

- (void)updateLongView:(float)brightness {
    float stage = 1 / 15.0;
    NSInteger level = brightness / stage;
    
    for (int i = 0; i < self.tipArray.count; i++) {
        UIImageView *img = self.tipArray[i];
        
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.orientationDidChange) {
        [UIView animateWithDuration:0.25 animations:^{
            self.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
        } completion:^(BOOL finished) {
            self.orientationDidChange = NO;
        }];
    } else {
        self.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    }
    
    self.backImage.center = CGPointMake(155 * 0.5, 155 * 0.5);
}

- (void)addNotification {
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] subscribeNext:^(id x) {
        self.orientationDidChange = YES;
        [self setNeedsLayout];
    }];
}

- (void)addObserver {
    [RACObserve([UIScreen mainScreen], brightness) subscribeNext:^(id x) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disappearAndFade) object:nil];
        [self appear];
        [self updateLongView:[x floatValue]];
    }];
}

- (void)appear {
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    if (!self.superview) {
        [keyWindow addSubview:self];
    }else {
        [keyWindow bringSubviewToFront:self];
    }
    self.alpha = 1.0;
    [self performSelector:@selector(disappearAndFade) withObject:nil afterDelay:3.0];
}

- (void)disappearAndFade {
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
