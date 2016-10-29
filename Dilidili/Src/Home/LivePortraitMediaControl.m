//
//  LivePortraitMediaControl.m
//  Dilidili
//
//  Created by iMac on 2016/10/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LivePortraitMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface LivePortraitMediaControl ()

/** 播放控制面板 */
@property (nonatomic, weak) UIControl *playbackControlPanel;
/** 小播放按钮 */
@property (nonatomic, weak) UIButton *littlePlaybackBtn;
/** 大播放按钮 */
@property (nonatomic, weak) UIButton *bigPlaybackBtn;

@end

@implementation LivePortraitMediaControl

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
        [backBtn setImage:[UIImage imageNamed:@"common_back_v2"] forState:UIControlStateNormal];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        backBtn.rac_command = self.handleBackCommand;
        [playbackControlPanel addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(playbackControlPanel.mas_top).offset(24.0);
            make.left.equalTo(playbackControlPanel.mas_left);
            make.width.mas_equalTo(27.0);
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
    }
    return _playbackControlPanel;
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
    _statusBarHidden = NO;
    [[self.handleStatusBarHiddenCommand execute:nil] subscribeNext:^(UIViewController *vc) {
        [vc setNeedsStatusBarAppearanceUpdate];
    }];
    [self cancelDelayedHide];
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

#pragma mark - HandleAction
#pragma mark 播放/暂停
- (void)handlePlayback:(id)sender
{
    BOOL isPlaying = [self.delegatePlayer isPlaying];
    self.littlePlaybackBtn.selected = !isPlaying;
    self.bigPlaybackBtn.selected = !isPlaying;
    if (isPlaying) {
        [self.delegatePlayer pause];
    }else {
        [self.delegatePlayer play];
    }
}

@end
