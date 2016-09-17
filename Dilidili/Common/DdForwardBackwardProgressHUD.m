//
//  DdForwardBackwardProgressHUD.m
//  Dilidili
//
//  Created by iMac on 16/9/10.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdForwardBackwardProgressHUD.h"
#import "DdFormatter.h"

@interface DdForwardBackwardProgressHUD ()
{
    BOOL _orientationDidChange;
}

@property (nonatomic, strong) UIVisualEffectView *forwardBackwardEffectView;
@property (nonatomic, strong) UIVisualEffectView *cancelEffectView;
@property (nonatomic, weak) UIButton *seekingBtn;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *seekingDurationLabel;
@property (nonatomic, weak) UIProgressView *seekingProgressView;

@end

@implementation DdForwardBackwardProgressHUD

+ (instancetype)sharedProgressHUD
{
    static DdForwardBackwardProgressHUD *sharedProgressHUD = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProgressHUD = [[self alloc] init];
    });
    return sharedProgressHUD;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 120, 88)]) {
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] subscribeNext:^(id x) {
            _orientationDidChange = YES;
            [self setNeedsLayout];
        }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIVisualEffectView *)forwardBackwardEffectView
{
    if (!_forwardBackwardEffectView) {
        UIVisualEffectView *forwardBackwardEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _forwardBackwardEffectView = forwardBackwardEffectView;
        forwardBackwardEffectView.frame = self.bounds;
        
        UIButton *seekingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _seekingBtn = seekingBtn;
        seekingBtn.userInteractionEnabled = NO;
        seekingBtn.adjustsImageWhenDisabled = NO;
        [seekingBtn setImage:[UIImage imageNamed:@"play_forward_icon"] forState:UIControlStateNormal];
        [seekingBtn setImage:[UIImage imageNamed:@"play_retreat_icon"] forState:UIControlStateSelected];
        [seekingBtn setImage:[UIImage imageNamed:@"cancel_forward_icon"] forState:UIControlStateDisabled];
        [seekingBtn sizeToFit];
        seekingBtn.top = 10.0;
        seekingBtn.centerX = forwardBackwardEffectView.width / 2;
        [forwardBackwardEffectView.contentView addSubview:seekingBtn];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, seekingBtn.bottom + 4, forwardBackwardEffectView.width, 18)];
        _timeLabel = timeLabel;
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        [forwardBackwardEffectView.contentView addSubview:timeLabel];
        
        UILabel *seekingDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeLabel.bottom, forwardBackwardEffectView.width, 14)];
        _seekingDurationLabel = seekingDurationLabel;
        seekingDurationLabel.font = [UIFont systemFontOfSize:11];
        seekingDurationLabel.textAlignment = NSTextAlignmentCenter;
        seekingDurationLabel.textColor = [UIColor whiteColor];
        [forwardBackwardEffectView.contentView addSubview:seekingDurationLabel];
        
        UIProgressView *seekingProgressView = [[UIProgressView alloc] init];
        _seekingProgressView = seekingProgressView;
        seekingProgressView.progressTintColor = kThemeColor;
        seekingProgressView.trackTintColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        seekingProgressView.top = seekingDurationLabel.bottom + 2.0;
        seekingProgressView.left = 8.0;
        seekingProgressView.width = forwardBackwardEffectView.width - 2 * seekingProgressView.left;
        [forwardBackwardEffectView.contentView addSubview:seekingProgressView];
    }
    return _forwardBackwardEffectView;
}

- (UIVisualEffectView *)cancelEffectView
{
    if (!_cancelEffectView) {
        UIVisualEffectView *cancelEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _cancelEffectView = cancelEffectView;
        cancelEffectView.frame = self.bounds;
        
        UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel_forward_icon"]];
        [cancelImageView sizeToFit];
        cancelImageView.top = 14.0;
        cancelImageView.centerX = cancelEffectView.width / 2;
        [cancelEffectView.contentView addSubview:cancelImageView];
        
        UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, cancelEffectView.height - 6 - 18, cancelEffectView.width - 2 * 6, 18)];
        cancelLabel.layer.cornerRadius = 6.0;
        cancelLabel.layer.masksToBounds = YES;
        cancelLabel.backgroundColor = [UIColor colorWithRed:138 / 255.0 green:44 / 255.0 blue:58 / 255.0 alpha:0.7];
        cancelLabel.font = [UIFont systemFontOfSize:10];
        cancelLabel.textAlignment = NSTextAlignmentCenter;
        cancelLabel.textColor = [UIColor whiteColor];
        cancelLabel.text = @"松开手指，取消进退";
        [cancelEffectView.contentView addSubview:cancelLabel];
    }
    return _cancelEffectView;
}

- (void)setSeekingDuration:(NSTimeInterval)seekingDuration
{
    if (self.currentPlaybackTime + seekingDuration > self.duration) {
        _wasCancelled = YES;
        self.seekingBtn.enabled = NO;
        _seekingDuration = self.duration - self.currentPlaybackTime;
    }else if (self.currentPlaybackTime + seekingDuration < 0) {
        _wasCancelled = YES;
        self.seekingBtn.enabled = NO;
        _seekingDuration = -self.currentPlaybackTime;
    }else {
        _wasCancelled = NO;
        self.seekingBtn.enabled = YES;
        _seekingDuration = seekingDuration;
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [DdFormatter stringForMediaTime:self.currentPlaybackTime + _seekingDuration], [DdFormatter stringForMediaTime:self.duration]];
    NSString *symbol;
    _seekingDuration >= 0 ? (symbol = @"+") : (symbol = @"-");
    self.seekingDurationLabel.text = [NSString stringWithFormat:@"%@%lu秒 - 中速进退", symbol, (NSUInteger)fabs(_seekingDuration)];
    self.seekingProgressView.progress = (self.currentPlaybackTime + _seekingDuration) / self.duration;
}

- (void)setIsForward:(BOOL)isForward
{
    _isForward = isForward;
    if (!self.seekingBtn.isEnabled) {
        self.seekingBtn.selected = NO;
    }else {
        self.seekingBtn.selected = !isForward;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_orientationDidChange) {
        [UIView animateWithDuration:0.25 animations:^{
            self.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
        } completion:^(BOOL finished) {
            _orientationDidChange = NO;
        }];
    } else {
        self.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    }
}

- (void)show
{
    [self hide];
    [self addSubview:self.forwardBackwardEffectView];
    _wasCancelled = NO;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [DdFormatter stringForMediaTime:self.currentPlaybackTime], [DdFormatter stringForMediaTime:self.duration]];
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    [keyWindow addSubview:self];
}

- (void)hide
{
    if (!self.superview) {
        return;
    }
    
    self.timeLabel.text = nil;
    self.seekingDurationLabel.text = nil;
    self.seekingProgressView.progress = 0.0;
    self.seekingBtn.enabled = YES;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

- (void)cancel
{
    _wasCancelled = YES;
    [_forwardBackwardEffectView removeFromSuperview];
    [self addSubview:self.cancelEffectView];
}

@end
