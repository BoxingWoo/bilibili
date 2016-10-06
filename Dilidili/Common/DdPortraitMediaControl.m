//
//  DdPortraitMediaControl.m
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdPortraitMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface DdPortraitMediaControl ()
{
    BOOL _isMediaSliderDragged;  //是否拖拽进度滑块
}

/** 播放控制面板 */
@property (nonatomic, weak) UIControl *playbackControlPanel;
/** 进度条 */
@property (nonatomic, weak) UIProgressView *progressView;
/** 小播放按钮 */
@property (nonatomic, weak) UIButton *littlePlaybackBtn;
/** 大播放按钮 */
@property (nonatomic, weak) UIButton *bigPlaybackBtn;
/** 当前视频时间标签 */
@property (nonatomic, weak) UILabel *currentTimeLabel;
/** 视频总时长标签 */
@property (nonatomic, weak) UILabel *totalDurationLabel;
/** 进度滑块 */
@property (nonatomic, weak) UISlider *mediaProgressSlider;

@end

@implementation DdPortraitMediaControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(showAndFade) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc
{
    DDLogWarn(@"%@ dealloc！", [self.class description]);
}

#pragma mark - 清理
- (void)clean
{
    [self removeMovieNotificationObservers];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPlaybackControlPanel) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

#pragma mark - 懒加载
- (UIControl *)playbackControlPanel
{
    if (!_playbackControlPanel) {
        UIControl *playbackControlPanel = [[UIControl alloc] initWithFrame:self.bounds];
        _playbackControlPanel = playbackControlPanel;
        [playbackControlPanel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playbackControlPanel];
        [playbackControlPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIImageView *playerTopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palyer_top_bg"]];
        [playbackControlPanel addSubview:playerTopImageView];
        [playerTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(playbackControlPanel);
            make.height.mas_equalTo(49.0);
        }];
        UIImageView *playerBottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palyer_bottom_bg"]];
        [playbackControlPanel addSubview:playerBottomImageView];
        [playerBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(playbackControlPanel);
            make.height.mas_equalTo(44.0);
        }];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.adjustsImageWhenHighlighted = NO;
        [backBtn setImage:[UIImage imageNamed:@"common_backShadow"] forState:UIControlStateNormal];
        backBtn.rac_command = self.handleBackCommand;
        [playbackControlPanel addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(playbackControlPanel.mas_top).offset(22.0);
            make.left.equalTo(playbackControlPanel.mas_left).offset(14.0);
        }];
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.adjustsImageWhenHighlighted = NO;
        [moreBtn setImage:[UIImage imageNamed:@"icmpv_more_light"] forState:UIControlStateNormal];
        moreBtn.rac_command = self.handleMoreCommand;
        [playbackControlPanel addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(playbackControlPanel.mas_right).offset(-16.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.title;
        [playbackControlPanel addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backBtn.mas_right).offset(16.0);
            make.right.equalTo(moreBtn.mas_left).offset(-16.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        [titleLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
        [titleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        
        UIButton *littlePlaybackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _littlePlaybackBtn = littlePlaybackBtn;
        littlePlaybackBtn.adjustsImageWhenHighlighted = NO;
        [littlePlaybackBtn setImage:[UIImage imageNamed:@"player_play_bottom_window"] forState:UIControlStateNormal];
        [littlePlaybackBtn setImage:[UIImage imageNamed:@"player_pause_bottom_window"] forState:UIControlStateSelected];
        littlePlaybackBtn.selected = YES;
        [littlePlaybackBtn addTarget:self action:@selector(handlePlayback:) forControlEvents:UIControlEventTouchUpInside];
        [playbackControlPanel addSubview:littlePlaybackBtn];
        [littlePlaybackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(playbackControlPanel.mas_bottom).offset(-8.0);
            make.left.equalTo(playbackControlPanel.mas_left).offset(12.0);
        }];
        UIButton *screenOrientationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        screenOrientationBtn.adjustsImageWhenHighlighted = NO;
        [screenOrientationBtn setImage:[UIImage imageNamed:@"player_fullScreen_iphone"] forState:UIControlStateNormal];
        screenOrientationBtn.rac_command = self.handleFullScreenCommand;
        [playbackControlPanel addSubview:screenOrientationBtn];
        [screenOrientationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(playbackControlPanel.mas_right).offset(-20.0);
            make.centerY.equalTo(littlePlaybackBtn.mas_centerY);
        }];
        UIButton *bigPlaybackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigPlaybackBtn = bigPlaybackBtn;
        bigPlaybackBtn.adjustsImageWhenHighlighted = NO;
        [bigPlaybackBtn setImage:[UIImage imageNamed:@"player_play_c"] forState:UIControlStateNormal];
        [bigPlaybackBtn setImage:[UIImage imageNamed:@"player_pause_c"] forState:UIControlStateSelected];
        bigPlaybackBtn.selected = YES;
        [bigPlaybackBtn addTarget:self action:@selector(handlePlayback:) forControlEvents:UIControlEventTouchUpInside];
        [playbackControlPanel addSubview:bigPlaybackBtn];
        [bigPlaybackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(screenOrientationBtn.mas_top).offset(-8.0);
            make.right.equalTo(playbackControlPanel.mas_right).offset(-14.0);
        }];
        
        UISlider *mediaProgressSlider = [[UISlider alloc] init];
        _mediaProgressSlider = mediaProgressSlider;
        mediaProgressSlider.minimumTrackTintColor = kThemeColor;
        mediaProgressSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [mediaProgressSlider setThumbImage:[UIImage imageNamed:@"player_slider_thumb"] forState:UIControlStateNormal];
        [mediaProgressSlider addTarget:self action:@selector(handleDragSlider:) forControlEvents:UIControlEventValueChanged];
        [playbackControlPanel addSubview:mediaProgressSlider];
        CGFloat sliderWidth = widthEx(138.0);
        [mediaProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(sliderWidth);
            make.centerX.equalTo(playbackControlPanel.mas_centerX).offset(-13.0);
            make.centerY.equalTo(littlePlaybackBtn.mas_centerY);
        }];
        UILabel *currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel = currentTimeLabel;
        currentTimeLabel.font = [UIFont systemFontOfSize:13];
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.text = @"00:00";
        [playbackControlPanel addSubview:currentTimeLabel];
        [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(mediaProgressSlider.mas_left).offset(-8.0);
            make.centerY.equalTo(mediaProgressSlider.mas_centerY);
        }];
        UILabel *totalDurationLabel = [[UILabel alloc] init];
        _totalDurationLabel = totalDurationLabel;
        totalDurationLabel.font = [UIFont systemFontOfSize:13];
        totalDurationLabel.textColor = [UIColor whiteColor];
        totalDurationLabel.text = @"00:00";
        [playbackControlPanel addSubview:totalDurationLabel];
        [totalDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mediaProgressSlider.mas_right).offset(8.0);
            make.centerY.equalTo(mediaProgressSlider.mas_centerY);
        }];
    }
    return _playbackControlPanel;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] init];
        _progressView = progressView;
        progressView.progressTintColor = kThemeColor;
        progressView.trackTintColor = [UIColor blackColor];
        [self addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
        }];
    }
    return _progressView;
}

#pragma mark - Utility
#pragma mark 刷新媒体控制器
- (void)refreshPortraitMediaControl
{
    [self installMovieNotificationObservers];
    [self showAndFade];
}

#pragma mark 配置通知中心
- (void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_delegatePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_delegatePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_delegatePlayer];
}

#pragma mark 移除通知中心
- (void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_delegatePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_delegatePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_delegatePlayer];
}

#pragma mark 加载进度
- (void)loadStateDidChange:(NSNotification *)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _delegatePlayer.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        
        DDLogInfo(@"loadStateDidChange: MPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        [self.delegatePlayer play];
        [self showNoFade];
        [self performSelector:@selector(hide) withObject:nil afterDelay:10.0];
        
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        DDLogInfo(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        DDLogInfo(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

#pragma mark 播放结束
- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            DDLogInfo(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            DDLogInfo(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            DDLogInfo(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            DDLogInfo(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

#pragma mark 播放状态
- (void)moviePlayBackStateDidChange:(NSNotification *)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_delegatePlayer.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            DDLogInfo(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_delegatePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            DDLogInfo(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_delegatePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            DDLogInfo(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_delegatePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            DDLogInfo(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_delegatePlayer.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            DDLogInfo(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_delegatePlayer.playbackState);
            break;
        }
        default: {
            DDLogInfo(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_delegatePlayer.playbackState);
            break;
        }
    }
}

#pragma mark 显示播放控制面板
- (void)showNoFade
{
    self.playbackControlPanel.hidden = NO;
    self.progressView.hidden = YES;
    _statusBarHidden = NO;
    [[self.handleStatusBarHiddenCommand execute:nil] subscribeNext:^(UIViewController *vc) {
        [vc setNeedsStatusBarAppearanceUpdate];
    }];
    [self cancelDelayedHide];
    [self refreshPlaybackControlPanel];
}

#pragma mark 显示播放控制面板(淡入动画)
- (void)showAndFade
{
    [self showNoFade];
    self.playbackControlPanel.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.playbackControlPanel.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:10.0];
    }];
}

#pragma mark 隐藏播放控制面板(淡出动画)
- (void)hide
{
    self.playbackControlPanel.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.playbackControlPanel.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.playbackControlPanel.hidden = YES;
        self.progressView.hidden = NO;
        _statusBarHidden = YES;
        [[self.handleStatusBarHiddenCommand execute:nil] subscribeNext:^(UIViewController *vc) {
            [vc setNeedsStatusBarAppearanceUpdate];
        }];
    }];
    
    [self cancelDelayedHide];
}

#pragma mark 取消延迟隐藏命令
- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

#pragma mark 刷新播放控制面板
- (void)refreshPlaybackControlPanel
{
    if (!self.playbackControlPanel.isHidden) {
        // duration
        NSTimeInterval duration = self.delegatePlayer.duration + 0.5;
        if (duration > 0) {
            self.mediaProgressSlider.maximumValue = duration;
            self.totalDurationLabel.text = [DdFormatter stringForMediaTime:duration];
        } else {
            self.totalDurationLabel.text = @"--:--";
            self.mediaProgressSlider.maximumValue = 1.0;
        }
        
        // position
        NSTimeInterval position;
        if (_isMediaSliderDragged) {
            position = self.mediaProgressSlider.value;
            self.delegatePlayer.currentPlaybackTime = position;
        } else {
            position = self.delegatePlayer.currentPlaybackTime;
        }
        position += 0.5;
        if (position > 0) {
            self.mediaProgressSlider.value = position;
        } else {
            self.mediaProgressSlider.value = 0.0;
        }
        self.currentTimeLabel.text = [DdFormatter stringForMediaTime:position];
        
        BOOL isPlaying = [self.delegatePlayer isPlaying];
        self.littlePlaybackBtn.selected = isPlaying;
        self.bigPlaybackBtn.selected = isPlaying;
        
        _isMediaSliderDragged = NO;
        
    }else {
        [self.progressView setProgress:self.delegatePlayer.currentPlaybackTime / self.delegatePlayer.duration];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPlaybackControlPanel) object:nil];
    [self performSelector:@selector(refreshPlaybackControlPanel) withObject:nil afterDelay:0.5];
}

#pragma mark - HandleAction
#pragma mark 播放/暂停
- (void)handlePlayback:(id)sender
{
    BOOL isPlaying = [self.delegatePlayer isPlaying];
    if (isPlaying) {
        [self.delegatePlayer pause];
    }else {
        [self.delegatePlayer play];
    }
    [self refreshPlaybackControlPanel];
}

#pragma mark 播放进度调整
- (void)handleDragSlider:(UISlider *)slider
{
    _isMediaSliderDragged = YES;
    [self showNoFade];
    [self performSelector:@selector(hide) withObject:nil afterDelay:10.0];
}

@end
