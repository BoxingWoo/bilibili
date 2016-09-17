//
//  DdLandscapeMediaControl.m
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdLandscapeMediaControl.h"
#import "BSCentralButton.h"
#import "DdBrightnessView.h"
#import "DdForwardBackwardProgressHUD.h"
#import "DdBufferProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <pop/pop.h>

#define kLMCTitleViewWidth widthEx(228.0)

@interface DdLandscapeMediaControl ()
{
    BOOL _isMediaSliderDragged;  //是否拖拽进度滑块
    BOOL _isVerticalMoved;  //是否垂直移动
    BOOL _isVolumeAdjusted;  //是否调节音量
}

#pragma mark 控制面板

@property (nonatomic, weak) UITapGestureRecognizer *playbackTap;  //播放控制点击手势
@property (nonatomic, weak) UIPanGestureRecognizer *pan;  //平移手势，用来控制音量、亮度、快进快退

/** 播放控制面板 */
@property (nonatomic, weak) UIView *playbackControlPanel;
/** 进度条 */
@property (nonatomic, weak) UIProgressView *progressView;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 当前视频时间标签 */
@property (nonatomic, weak) UILabel *currentTimeLabel;
/** 视频总时长标签 */
@property (nonatomic, weak) UILabel *totalDurationLabel;
/** 进度滑块 */
@property (nonatomic, weak) UISlider *mediaProgressSlider;
/** 播放按钮 */
@property (nonatomic, weak) UIButton *playbackBtn;
/** 缓冲指示视图 */
@property (nonatomic, weak) DdBufferProgressView *bufferProgressView;

#pragma mark 更多

/** 更多视图 */
@property (nonatomic, strong) UIView *moreView;
/** 更多内容视图 */
@property (nonatomic, weak) UIVisualEffectView *moreEffectView;
/** 音量🔊滑块 */
@property (nonatomic, weak) UISlider *volumeSlider;
/** 系统音量滑块 */
@property (nonatomic, strong) UISlider *systemVolumeSlider;
/** 亮度☼滑块 */
@property (nonatomic, weak) UISlider *brightnessSlider;
/** 播放模式按钮数组 */
@property (nonatomic, copy) NSArray *playbackModeButtons;
/** 屏占比按钮数组 */
@property (nonatomic, copy) NSArray *scalingModeButtons;
/** 是否水平翻转 */
@property (nonatomic, assign) BOOL isMirrorFlip;

@end

@implementation DdLandscapeMediaControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in volumeView.subviews){
            if ([view isKindOfClass:NSClassFromString(@"MPVolumeSlider")]){
                _systemVolumeSlider = (UISlider *)view;
                break;
            }
        }
        
        [DdBrightnessView sharedBrightnessView];
        
        //播放/暂停
        UITapGestureRecognizer *playbackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlayback:)];
        _playbackTap = playbackTap;
        playbackTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:playbackTap];
        
        //显示播放控制面板
        UITapGestureRecognizer *showTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndFade)];
        [showTap requireGestureRecognizerToFail:playbackTap];
        [self addGestureRecognizer:showTap];
        
        //平移手势，用来控制音量、亮度、快进快退
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _pan = pan;
        [self addGestureRecognizer:pan];
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshBufferProgressView) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPlaybackControlPanel) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

#pragma mark - 懒加载

- (UIView *)playbackControlPanel
{
    if(!_playbackControlPanel) {
        UIView *playbackControlPanel = [[UIView alloc] init];
        _playbackControlPanel = playbackControlPanel;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [tap requireGestureRecognizerToFail:_playbackTap];
        [playbackControlPanel addGestureRecognizer:tap];
        [self addSubview:playbackControlPanel];
        [playbackControlPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *topEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [playbackControlPanel addSubview:topEffectView];
        [topEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(playbackControlPanel);
            make.height.mas_equalTo(52.0);
        }];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.adjustsImageWhenHighlighted = NO;
        [backBtn setImage:[UIImage imageNamed:@"icnav_back_light"] forState:UIControlStateNormal];
        backBtn.rac_command = self.handleBackCommand;
        [topEffectView.contentView addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topEffectView.contentView.mas_top).offset(22.0);
            make.left.equalTo(topEffectView.contentView.mas_left).offset(10.0);
        }];
        UIView *titleView = [[UIView alloc] init];
        titleView.clipsToBounds = YES;
        [topEffectView.contentView addSubview:titleView];
        CGFloat titleViewHeight = 18.0;
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backBtn.mas_right).offset(6.0);
            make.centerY.equalTo(backBtn.mas_centerY);
            make.width.mas_equalTo(kLMCTitleViewWidth);
            make.height.mas_equalTo(titleViewHeight);
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = self.title;
        [titleLabel sizeToFit];
        titleLabel.left = 0.0;
        titleLabel.centerY = titleViewHeight / 2;
        [titleView addSubview:titleLabel];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.adjustsImageWhenHighlighted = NO;
        [moreBtn setImage:[UIImage imageNamed:@"icmpv_more_light"] forState:UIControlStateNormal];
#pragma mark Action - 更多
        @weakify(self);
        [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self hide];
            [self addSubview:self.moreView];
            self.volumeSlider.value = [[AVAudioSession sharedInstance] outputVolume];
            self.brightnessSlider.value = [UIScreen mainScreen].brightness;
            self.moreEffectView.left = self.moreView.width;
            [UIView animateWithDuration:0.25 animations:^{
                self.moreEffectView.left = self.moreView.width - self.moreEffectView.width;
            } completion:^(BOOL finished) {
                self.pan.enabled = NO;
            }];
        }];
        [topEffectView.contentView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topEffectView.contentView.mas_right).offset(-10.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.adjustsImageWhenHighlighted = NO;
        settingBtn.tintColor = [UIColor whiteColor];
        UIImage *settingImage = [[UIImage imageNamed:@"player_danmaku_setup"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [settingBtn setImage:settingImage forState:UIControlStateNormal];
        [topEffectView.contentView addSubview:settingBtn];
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moreBtn.mas_left).offset(-16.0);
            make.centerY.equalTo(moreBtn.mas_centerY);
        }];
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.adjustsImageWhenHighlighted = NO;
        [shareBtn setImage:[UIImage imageNamed:@"player_share"] forState:UIControlStateNormal];
        [topEffectView.contentView addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(settingBtn.mas_left).offset(-14.0);
            make.centerY.equalTo(moreBtn.mas_centerY);
        }];
        UIButton *coinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        coinBtn.adjustsImageWhenHighlighted = NO;
        [coinBtn setImage:[UIImage imageNamed:@"player_addcoin"] forState:UIControlStateNormal];
        [topEffectView.contentView addSubview:coinBtn];
        [coinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(shareBtn.mas_left).offset(-14.0);
            make.centerY.equalTo(moreBtn.mas_centerY);
        }];
        
        UIVisualEffectView *bottomEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [playbackControlPanel addSubview:bottomEffectView];
        [bottomEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(playbackControlPanel);
            make.height.mas_equalTo(36.0);
        }];
        
        UIButton *addDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addDanmakuBtn.adjustsImageWhenHighlighted = NO;
        [addDanmakuBtn setImage:[UIImage imageNamed:@"icmpv_add_danmaku_light"] forState:UIControlStateNormal];
        [bottomEffectView.contentView addSubview:addDanmakuBtn];
        [addDanmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomEffectView.contentView.mas_top).offset(6.0);
            make.left.equalTo(bottomEffectView.contentView.mas_left).offset(8.0);
        }];
        UIButton *showDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showDanmakuBtn.adjustsImageWhenHighlighted = NO;
        [showDanmakuBtn setImage:[UIImage imageNamed:@"icmpv_toggle_danmaku_hided_light"] forState:UIControlStateNormal];
        [showDanmakuBtn setImage:[UIImage imageNamed:@"icmpv_toggle_danmaku_showed_light"] forState:UIControlStateSelected];
        [bottomEffectView.contentView addSubview:showDanmakuBtn];
        [showDanmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addDanmakuBtn.mas_right).offset(14.0);
            make.centerY.equalTo(addDanmakuBtn.mas_centerY);
        }];
        
        UIButton *screenOrientationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        screenOrientationBtn.adjustsImageWhenHighlighted = NO;
        [screenOrientationBtn setImage:[UIImage imageNamed:@"player_window_iphone"] forState:UIControlStateNormal];
        screenOrientationBtn.rac_command = self.handleFullScreenCommand;
        [bottomEffectView.contentView addSubview:screenOrientationBtn];
        [screenOrientationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomEffectView.contentView.mas_right).offset(-12.0);
            make.centerY.equalTo(addDanmakuBtn.mas_centerY);
        }];
        UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lockBtn.adjustsImageWhenHighlighted = NO;
        [lockBtn setImage:[UIImage imageNamed:@"player_lock"] forState:UIControlStateNormal];
        [bottomEffectView.contentView addSubview:lockBtn];
        [lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(screenOrientationBtn.mas_left).offset(-26.0);
            make.centerY.equalTo(screenOrientationBtn.mas_centerY);
        }];
        UIButton *chapterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chapterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [chapterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chapterBtn setTitle:@"选集" forState:UIControlStateNormal];
        [bottomEffectView.contentView addSubview:chapterBtn];
        [chapterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lockBtn.mas_left).offset(-22.0);
            make.centerY.equalTo(screenOrientationBtn.mas_centerY);
        }];
        UIButton *qualityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qualityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qualityBtn setTitle:@"流畅" forState:UIControlStateNormal];
        [bottomEffectView.contentView addSubview:qualityBtn];
        [qualityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(chapterBtn.mas_left).offset(-14.0);
            make.centerY.equalTo(screenOrientationBtn.mas_centerY);
        }];
        
        UISlider *mediaProgressSlider = [[UISlider alloc] init];
        _mediaProgressSlider = mediaProgressSlider;
        mediaProgressSlider.minimumTrackTintColor = kThemeColor;
        mediaProgressSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [mediaProgressSlider setThumbImage:[UIImage imageNamed:@"player_slider_thumb"] forState:UIControlStateNormal];
        [mediaProgressSlider addTarget:self action:@selector(handleDragSlider:) forControlEvents:UIControlEventValueChanged];
        [bottomEffectView.contentView addSubview:mediaProgressSlider];
        CGFloat sliderWidth = widthEx(208.0);
        [mediaProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(sliderWidth);
            make.centerX.equalTo(bottomEffectView.contentView.mas_centerX).offset(-44.0);
            make.centerY.equalTo(addDanmakuBtn.mas_centerY);
        }];
        UILabel *currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel = currentTimeLabel;
        currentTimeLabel.font = [UIFont systemFontOfSize:13];
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.text = @"00:00";
        [bottomEffectView.contentView addSubview:currentTimeLabel];
        [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(mediaProgressSlider.mas_left).offset(-8.0);
            make.centerY.equalTo(mediaProgressSlider.mas_centerY);
        }];
        UILabel *totalDurationLabel = [[UILabel alloc] init];
        _totalDurationLabel = totalDurationLabel;
        totalDurationLabel.font = [UIFont systemFontOfSize:13];
        totalDurationLabel.textColor = [UIColor whiteColor];
        totalDurationLabel.text = @"00:00";
        [bottomEffectView.contentView addSubview:totalDurationLabel];
        [totalDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mediaProgressSlider.mas_right).offset(8.0);
            make.centerY.equalTo(mediaProgressSlider.mas_centerY);
        }];
        
        UIButton *playbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playbackBtn = playbackBtn;
        playbackBtn.adjustsImageWhenHighlighted = NO;
        [playbackBtn setImage:[UIImage imageNamed:@"player_play_c"] forState:UIControlStateNormal];
        [playbackBtn setImage:[UIImage imageNamed:@"player_pause_c"] forState:UIControlStateSelected];
        playbackBtn.selected = YES;
        [playbackBtn addTarget:self action:@selector(handlePlayback:) forControlEvents:UIControlEventTouchUpInside];
        [playbackControlPanel addSubview:playbackBtn];
        [playbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomEffectView.mas_top).offset(-6.0);
            make.right.equalTo(playbackControlPanel.mas_right).offset(-14.0);
        }];
    }
    return _playbackControlPanel;
}

- (DdBufferProgressView *)bufferProgressView
{
    if (!_bufferProgressView) {
        DdBufferProgressView *bufferProgressView = [[DdBufferProgressView alloc] init];
        _bufferProgressView = bufferProgressView;
        [self addSubview:bufferProgressView];
        [bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_centerY);
        }];
    }
    return _bufferProgressView;
}

- (UIView *)moreView
{
    if (!_moreView) {
        UIView *moreView = [[UIView alloc] initWithFrame:self.bounds];
        _moreView = moreView;
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [UIView animateWithDuration:0.25 animations:^{
                self.moreEffectView.left = self.moreView.right;
            } completion:^(BOOL finished) {
                [self.moreView removeFromSuperview];
                self.pan.enabled = YES;
            }];
        }];
        [moreView addGestureRecognizer:tap];
        
        UIVisualEffectView *moreEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _moreEffectView = moreEffectView;
        moreEffectView.width = 274.0;
        moreEffectView.height = moreView.height;
        moreEffectView.top = 0.0;
        moreEffectView.left = moreView.width - moreEffectView.width;
        [moreView addSubview:moreEffectView];
        
        UIButton *nuvoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nuvoiceBtn.adjustsImageWhenHighlighted = NO;
        [nuvoiceBtn setImage:[UIImage imageNamed:@"player_nuvoice"] forState:UIControlStateNormal];
        [moreEffectView.contentView addSubview:nuvoiceBtn];
        [nuvoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moreEffectView.contentView.mas_left).offset(22.0);
            make.top.equalTo(moreEffectView.contentView.mas_top).offset(26.0);
        }];
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.adjustsImageWhenHighlighted = NO;
        [voiceBtn setImage:[UIImage imageNamed:@"player_voice"] forState:UIControlStateNormal];
        [moreEffectView.contentView addSubview:voiceBtn];
        [voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moreEffectView.contentView).offset(-40.0);
            make.centerY.equalTo(nuvoiceBtn.mas_centerY);
        }];
        UISlider *volumeSlider = [[UISlider alloc] init];
        _volumeSlider = volumeSlider;
        volumeSlider.thumbTintColor = [UIColor whiteColor];
        volumeSlider.minimumTrackTintColor = kThemeColor;
        volumeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        [volumeSlider addTarget:self action:@selector(handleDragVolumeSlider:) forControlEvents:UIControlEventValueChanged];
        [moreEffectView.contentView addSubview:volumeSlider];
        [volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nuvoiceBtn.mas_right).offset(8.0);
            make.right.equalTo(voiceBtn.mas_left).offset(-8.0);
            make.centerY.equalTo(nuvoiceBtn.mas_centerY);
        }];
        
        UIButton *minBrightnessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        minBrightnessBtn.adjustsImageWhenHighlighted = NO;
        [minBrightnessBtn setImage:[UIImage imageNamed:@"player_lightness_mum"] forState:UIControlStateNormal];
        [moreEffectView.contentView addSubview:minBrightnessBtn];
        [minBrightnessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(nuvoiceBtn.mas_right);
            make.top.equalTo(nuvoiceBtn.mas_bottom).offset(32.0);
        }];
        UIButton *maxBrightnessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maxBrightnessBtn.adjustsImageWhenHighlighted = NO;
        [maxBrightnessBtn setImage:[UIImage imageNamed:@"player_lightness_max"] forState:UIControlStateNormal];
        [moreEffectView.contentView addSubview:maxBrightnessBtn];
        [maxBrightnessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(voiceBtn.mas_left);
            make.centerY.equalTo(minBrightnessBtn.mas_centerY);
        }];
        
        UISlider *brightnessSlider = [[UISlider alloc] init];
        _brightnessSlider = brightnessSlider;
        brightnessSlider.thumbTintColor = [UIColor whiteColor];
        brightnessSlider.minimumTrackTintColor = kThemeColor;
        brightnessSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        [brightnessSlider addTarget:self action:@selector(handleDragBrightnessSlider:) forControlEvents:UIControlEventValueChanged];
        [moreEffectView.contentView addSubview:brightnessSlider];
        [brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(minBrightnessBtn.mas_right).offset(8.0);
            make.right.equalTo(maxBrightnessBtn.mas_left).offset(-8.0);
            make.centerY.equalTo(minBrightnessBtn.mas_centerY);
        }];
        
        BSCentralButton *backgroundMusicBtn = [BSCentralButton buttonWithType:UIButtonTypeCustom andContentSpace:4.0];
        backgroundMusicBtn.tintColor = [UIColor whiteColor];
        backgroundMusicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [backgroundMusicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backgroundMusicBtn setTitle:@"后台音乐" forState:UIControlStateNormal];
        UIImage *backgroundMusicImage = [[UIImage imageNamed:@"player_background_music"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [backgroundMusicBtn setImage:backgroundMusicImage forState:UIControlStateNormal];
#pragma mark Action - 后台音乐
        [[backgroundMusicBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
            button.selected = !button.isSelected;
            if (button.isSelected) {
                button.tintColor = kThemeColor;
            }else {
                button.tintColor = [UIColor whiteColor];
            }
        }];
        [moreEffectView.contentView addSubview:backgroundMusicBtn];
        [backgroundMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moreEffectView.contentView.mas_centerX).offset(-8.0);
            make.centerY.equalTo(moreEffectView.contentView.mas_centerY);
        }];
        
        BSCentralButton *mirrorFlipBtn = [BSCentralButton buttonWithType:UIButtonTypeCustom andContentSpace:4.0];
        mirrorFlipBtn.tintColor = [UIColor whiteColor];
        mirrorFlipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [mirrorFlipBtn setTitle:@"镜像翻转" forState:UIControlStateNormal];
        UIImage *mirrorFlipImage = [[UIImage imageNamed:@"player_mirrorFlip"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [mirrorFlipBtn setImage:mirrorFlipImage forState:UIControlStateNormal];
#pragma mark Action - 镜像翻转
        [[mirrorFlipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
            @strongify(self);
            button.selected = !button.isSelected;
            self.isMirrorFlip = button.isSelected;
            if (button.isSelected) {
                button.tintColor = kThemeColor;
                self.delegatePlayer.view.transform = CGAffineTransformMakeScale(-fabs(self.delegatePlayer.view.layer.transformScaleX), fabs(self.delegatePlayer.view.layer.transformScaleY));
            }else {
                button.tintColor = [UIColor whiteColor];
                self.delegatePlayer.view.transform = CGAffineTransformMakeScale(fabs(self.delegatePlayer.view.layer.transformScaleX), fabs(self.delegatePlayer.view.layer.transformScaleY));
            }
        }];
        [moreEffectView.contentView addSubview:mirrorFlipBtn];
        [mirrorFlipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moreEffectView.contentView.mas_centerX).offset(8.0);
            make.centerY.equalTo(backgroundMusicBtn.mas_centerY);
        }];
        
        NSArray *scalingModes = @[@"默认", @"全屏", @"16:9", @"4:3"];
        UIView *scalingModeView = [[UIView alloc] init];
        scalingModeView.width = moreEffectView.width - 12.0 - 30.0;
        scalingModeView.height = 52.0;
        scalingModeView.left = 12.0;
        scalingModeView.bottom = moreEffectView.height;
        [moreEffectView.contentView addSubview:scalingModeView];
        
        CGFloat scalingItemWidth = 32.0;
        CGFloat scalingItemInset = (scalingModeView.width - scalingItemWidth * scalingModes.count) / (scalingModes.count - 1);
        for (NSInteger i = 0; i < scalingModes.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:kThemeColor forState:UIControlStateSelected];
            [button setTitle:scalingModes[i] forState:UIControlStateNormal];
            if (i == 0) button.selected = YES;
#pragma mark Action - 屏占比
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                @strongify(self);
                for (UIButton *btn in self.scalingModeButtons) {
                    btn.selected = NO;
                }
                x.selected = YES;
                NSInteger scaleX;
                self.isMirrorFlip ? (scaleX = -1) : (scaleX = 1);
                self.delegatePlayer.view.transform = CGAffineTransformMakeScale(scaleX, 1.0);
                NSUInteger index = [self.scalingModeButtons indexOfObject:x];
                switch (index) {
                    case 0:  //默认
                    {
                        self.delegatePlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
                    }
                        break;
                    case 1:  //全屏
                    {
                        self.delegatePlayer.scalingMode = IJKMPMovieScalingModeFill;
                    }
                        break;
                    case 2:  //16:9
                    {
                        self.delegatePlayer.scalingMode = IJKMPMovieScalingModeFill;
                        self.delegatePlayer.scalingMode = IJKMPMovieScalingModeFill;
                        CGFloat newHeight = 9 * self.delegatePlayer.view.width / 16;
                        float ratio = newHeight / self.delegatePlayer.view.height;
                        self.delegatePlayer.view.transform = CGAffineTransformMakeScale(scaleX * fabs(self.delegatePlayer.view.layer.transformScaleX), ratio);
                    }
                        break;
                    case 3:  //4:3
                    {
                        self.delegatePlayer.scalingMode = IJKMPMovieScalingModeFill;
                        CGFloat newWidth = 4 * self.delegatePlayer.view.height / 3;
                        float ratio = newWidth / self.delegatePlayer.view.width;
                        self.delegatePlayer.view.transform = CGAffineTransformMakeScale(ratio * scaleX, fabs(self.delegatePlayer.view.layer.transformScaleY));
                    }
                        break;
                    default:
                        self.delegatePlayer.scalingMode = IJKMPMovieScalingModeNone;
                        break;
                }
            }];
            button.width = scalingItemWidth;
            button.height = scalingModeView.height;
            button.top = 0;
            button.left = i * (scalingItemWidth + scalingItemInset);
            [scalingModeView addSubview:button];
        }
        _scalingModeButtons = [NSArray arrayWithArray:scalingModeView.subviews];
        
        UIView *separatedLine1 = [[UIView alloc] init];
        separatedLine1.userInteractionEnabled = NO;
        separatedLine1.layer.cornerRadius = 1.0;
        separatedLine1.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        separatedLine1.width = scalingModeView.width;
        separatedLine1.height = 1.0;
        separatedLine1.left = scalingModeView.left;
        separatedLine1.bottom = scalingModeView.top;
        [moreEffectView.contentView addSubview:separatedLine1];
        
        NSArray *playbackModes = @[@"关闭循环", @"重复单集", @"全部重复", @"顺序播放"];
        UIView *playbackModeView = [[UIView alloc] init];
        playbackModeView.width = scalingModeView.width;
        playbackModeView.height = scalingModeView.height;
        playbackModeView.left = scalingModeView.left;
        playbackModeView.bottom = separatedLine1.top;
        [moreEffectView.contentView addSubview:playbackModeView];
        
        CGFloat placbackModeItemWidth = 54.0;
        CGFloat playbackModeItemInset = (playbackModeView.width - placbackModeItemWidth * playbackModes.count) / (playbackModes.count - 1);
        for (NSInteger i = 0; i < playbackModes.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:kThemeColor forState:UIControlStateSelected];
            [button setTitle:playbackModes[i] forState:UIControlStateNormal];
            if (i == 0) button.selected = YES;
#pragma mark Action - 播放模式
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                @strongify(self);
                for (UIButton *btn in self.playbackModeButtons) {
                    btn.selected = NO;
                }
                x.selected = YES;
            }];
            button.width = placbackModeItemWidth;
            button.height = playbackModeView.height;
            button.top = 0;
            button.left = i * (placbackModeItemWidth + playbackModeItemInset);
            [playbackModeView addSubview:button];
        }
        _playbackModeButtons = [NSArray arrayWithArray:playbackModeView.subviews];
        
        UIView *separatedLine2 = [[UIView alloc] init];
        separatedLine2.userInteractionEnabled = NO;
        separatedLine2.layer.cornerRadius = separatedLine1.layer.cornerRadius;
        separatedLine2.backgroundColor = separatedLine1.backgroundColor;
        separatedLine2.width = separatedLine1.width;
        separatedLine2.height = separatedLine1.height;
        separatedLine2.left = separatedLine1.left;
        separatedLine2.bottom = playbackModeView.top;
        [moreEffectView.contentView addSubview:separatedLine2];
        
    }
    
    return _moreView;
}

#pragma mark - Utility
#pragma mark 刷新媒体控制器
- (void)refreshLandscapeMediaControl
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
    
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    // add event handler, for this example, it is `volumeChange:` method
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

#pragma mark 移除通知中心
- (void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_delegatePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_delegatePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_delegatePlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
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
        [_bufferProgressView removeFromSuperview];
        [self.delegatePlayer play];
        [self showNoFade];
        [self performSelector:@selector(hide) withObject:nil afterDelay:10.0];
        
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        DDLogInfo(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        self.bufferProgressView.hidden = NO;
        [self refreshBufferProgressView];
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
    if (self.titleLabel.width > kLMCTitleViewWidth) {
        CGFloat delta = self.titleLabel.width - kLMCTitleViewWidth;
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
        animation.fromValue = @(0);
        animation.toValue = @(-delta);
        animation.duration = delta * 1 / 30;
        animation.autoreverses = YES;
        animation.repeatForever = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        [self.titleLabel.layer pop_addAnimation:animation forKey:@"title_translationX"];
    }
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
        _statusBarHidden = YES;
        [[self.handleStatusBarHiddenCommand execute:nil] subscribeNext:^(UIViewController *vc) {
            [vc setNeedsStatusBarAppearanceUpdate];
        }];
        [self.titleLabel.layer pop_removeAnimationForKey:@"title_translationX"];
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
    self.playbackBtn.selected = isPlaying;
    
    _isMediaSliderDragged = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPlaybackControlPanel) object:nil];
    if (!self.playbackControlPanel.isHidden) {
        [self performSelector:@selector(refreshPlaybackControlPanel) withObject:nil afterDelay:0.5];
    }
}

#pragma mark 刷新缓冲指示视图
- (void)refreshBufferProgressView
{
    if (self.delegatePlayer.loadState == IJKMPMovieLoadStateStalled) {
        [_bufferProgressView setBufferingProgress:self.delegatePlayer.bufferingProgress];
        [self performSelector:@selector(refreshBufferProgressView) withObject:nil afterDelay:1.0];
    }
}

#pragma mark 监听硬件按钮音量调节
- (void)volumeChanged:(NSNotification *)notification
{
    _volumeSlider.value = [notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
}

#pragma mark 垂直移动
- (void)verticalMoved:(float)value
{
    _isVolumeAdjusted ? (self.systemVolumeSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

#pragma mark 水平移动
- (void)horizontalMoved:(float)value
{
    DdForwardBackwardProgressHUD *forwardBackwardProgressHUD = [DdForwardBackwardProgressHUD sharedProgressHUD];
    float ratio = forwardBackwardProgressHUD.duration / 10000;
    forwardBackwardProgressHUD.seekingDuration += value * ratio;
    value >= 0 ? (forwardBackwardProgressHUD.isForward = YES) : (forwardBackwardProgressHUD.isForward = NO);
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
    [self refreshPlaybackControlPanel];
}

#pragma mark 音量调整
- (void)handleDragVolumeSlider:(UISlider *)slider
{
    _systemVolumeSlider.value = slider.value;
}

#pragma mark 亮度调整
- (void)handleDragBrightnessSlider:(UISlider *)slider
{
    [UIScreen mainScreen].brightness = slider.value;
}

#pragma mark 平移手势，用来控制音量、亮度、快进快退
- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    //根据在view上Pan的位置，确定是调节音量、亮度还是快进快退
    //需要响应水平移动和垂直移动
    
    //获取位置
    CGPoint locationPoint = [panGesture locationInView:panGesture.view];
    
    //根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [panGesture velocityInView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            //使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x < y) { //垂直移动
                _isVerticalMoved = YES;
                if (locationPoint.x > self.width / 2) { //状态改为音量调节
                    _isVolumeAdjusted = YES;
                }else { //状态改为亮度调节
                    _isVolumeAdjusted = NO;
                }
            }else { //水平移动
                _isVerticalMoved = NO;
                [DdBrightnessView hide:NO];
                DdForwardBackwardProgressHUD *forwardBackwardProgressHUD = [DdForwardBackwardProgressHUD sharedProgressHUD];
                forwardBackwardProgressHUD.currentPlaybackTime = self.delegatePlayer.currentPlaybackTime;
                forwardBackwardProgressHUD.duration = self.delegatePlayer.duration;
                [forwardBackwardProgressHUD show];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (_isVerticalMoved) {
                [self verticalMoved:veloctyPoint.y];
            }else {
                if (locationPoint.x >= self.width - 10 || locationPoint.x <= 10) {
                    DdForwardBackwardProgressHUD *forwardBackwardProgressHUD = [DdForwardBackwardProgressHUD sharedProgressHUD];
                    [forwardBackwardProgressHUD cancel];
                }else {
                    [self horizontalMoved:veloctyPoint.x];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (!_isVerticalMoved) {
                DdForwardBackwardProgressHUD *forwardBackwardProgressHUD = [DdForwardBackwardProgressHUD sharedProgressHUD];
                if (!forwardBackwardProgressHUD.wasCancelled) {
                    self.delegatePlayer.currentPlaybackTime = forwardBackwardProgressHUD.currentPlaybackTime + forwardBackwardProgressHUD.seekingDuration;
                }
                [forwardBackwardProgressHUD hide];
            }
            //把状态复原
            _isVerticalMoved = NO;
            _isVolumeAdjusted = NO;
            break;
        }
        default:
            break;
    }
}

@end
