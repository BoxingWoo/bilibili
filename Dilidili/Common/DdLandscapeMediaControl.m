//
//  DdLandscapeMediaControl.m
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdLandscapeMediaControl.h"
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "DdDanmakuViewModel.h"
#import "DdPlayUserDefaults.h"
#import "BSCentralButton.h"
#import "BSAlertView.h"
#import "DdBrightnessView.h"
#import "DdForwardBackwardProgressHUD.h"
#import "DdBufferProgressView.h"
#import <pop/POP.h>

#define kLMCTitleViewWidth widthEx(228.0)

@interface DdLandscapeMediaControl () <UITextFieldDelegate>
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
/** 后台音乐按钮 */
@property (nonatomic, weak) BSCentralButton *backgroundMusicBtn;
/** 播放模式按钮数组 */
@property (nonatomic, copy) NSArray *playbackModeButtons;
/** 屏占比按钮数组 */
@property (nonatomic, copy) NSArray *scalingModeButtons;
/** 是否水平翻转 */
@property (nonatomic, assign) BOOL isMirrorFlip;

#pragma mark 弹幕设置

/** 设置视图 */
@property (nonatomic, strong) UIView *settingView;
/** 设置内容视图 */
@property (nonatomic, weak) UIVisualEffectView *settingEffectView;
/** 屏蔽选项按钮数组(1、顶部，2、滚动，3、底部，4、游客，5、彩色) */
@property (nonatomic, copy) NSArray <UIButton *> *shieldingOptionButtons;
/** 同屏最大弹幕数滑块 */
@property (nonatomic, weak) UISlider *screenMaxlimitSlider;
/** 速度滑块 */
@property (nonatomic, weak) UISlider *speedSlider;
/** 透明度滑块 */
@property (nonatomic, weak) UISlider *opacitySlider;
/** 同屏最大弹幕数标签 */
@property (nonatomic, weak) UILabel *screenMaxlimitLabel;
/** 速度标签 */
@property (nonatomic, weak) UILabel *speedLabel;
/** 透明度标签 */
@property (nonatomic, weak) UILabel *opacityLabel;

#pragma mark 弹幕输入

/** 弹幕输入视图 */
@property (nonatomic, strong) UIView *danmakuEntryView;
/** 弹幕输入框 */
@property (nonatomic, weak) UITextField *danmakuTextField;
/** 弹幕字体大小按钮数组 */
@property (nonatomic, copy) NSArray <UIButton *> *fontSizeButtons;
/** 弹幕样式按钮数组 */
@property (nonatomic, copy) NSArray <UIButton *> *styleButtons;
/** 弹幕字体颜色按钮 */
@property (nonatomic, weak) UIButton *textColorButton;

#pragma mark 锁屏

/** 锁屏🔒视图 */
@property (nonatomic, strong) UIControl *lockView;
/** 锁屏内容视图 */
@property (nonatomic, weak) UIControl *lockContentView;
/** 是否为锁屏状态 */
@property (nonatomic, assign) BOOL isLocked;

@end

@implementation DdLandscapeMediaControl

NSInteger fontSizes[] = {DdDanmakuFontSizeSmall, DdDanmakuFontSizeNormal};
NSInteger styles[] = {DdDanmakuFloatTop, DdDanmakuWalkR2L, DdDanmakuFloatBottom};
NSInteger textColorValues[] = {DdDanmakuPurple, DdDanmakuBule, DdDanmakuMagenta, DdDanmakuCyan, DdDanmakuGreen, DdDanmakuYellow, DdDanmakuRed, DdDanmakuWhite};

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _isLocked = NO;
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in volumeView.subviews){
            if ([view isKindOfClass:NSClassFromString(@"MPVolumeSlider")]){
                _systemVolumeSlider = (UISlider *)view;
                break;
            }
        }
        
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
            make.left.equalTo(topEffectView.contentView.mas_left);
            make.width.mas_equalTo(36.0);
        }];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        UIView *titleView = [[UIView alloc] init];
        titleView.clipsToBounds = YES;
        [topEffectView.contentView addSubview:titleView];
        CGFloat titleViewHeight = 18.0;
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backBtn.mas_right);
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
        
        @weakify(self);
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.adjustsImageWhenHighlighted = NO;
        [moreBtn setImage:[UIImage imageNamed:@"icmpv_more_light"] forState:UIControlStateNormal];
#pragma mark Action - 显示更多视图
        [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self hide];
            [self addSubview:self.moreView];
            self.volumeSlider.value = [[AVAudioSession sharedInstance] outputVolume];
            self.brightnessSlider.value = [UIScreen mainScreen].brightness;
            DdPlayUserDefaults *playUserDefaults = [DdPlayUserDefaults sharedInstance];
            self.backgroundMusicBtn.selected = playUserDefaults.activeBackgroundPlayback;
            if (self.backgroundMusicBtn.isSelected) {
                self.backgroundMusicBtn.tintColor = kThemeColor;
            }else {
                self.backgroundMusicBtn.tintColor = [UIColor whiteColor];
            }
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
#pragma mark Action - 显示弹幕设置视图
        [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hide];
            [self addSubview:self.settingView];
            DdDanmakuUserDefaults *danmakuUserDefaults = [DdDanmakuUserDefaults sharedInstance];
            if (danmakuUserDefaults.shieldingOption & DdDanmakuShieldingFloatTop) {
                [self.shieldingOptionButtons[0] setSelected:YES];
            }else {
                [self.shieldingOptionButtons[0] setSelected:NO];
            }
            if (danmakuUserDefaults.shieldingOption & DdDanmakuShieldingWalk) {
                [self.shieldingOptionButtons[1] setSelected:YES];
            }else {
                [self.shieldingOptionButtons[1] setSelected:NO];
            }
            if (danmakuUserDefaults.shieldingOption & DdDanmakuShieldingFloatBottom) {
                [self.shieldingOptionButtons[2] setSelected:YES];
            }else {
                [self.shieldingOptionButtons[2] setSelected:NO];
            }
            if (danmakuUserDefaults.shieldingOption & DdDanmakuShieldingVisitor) {
                [self.shieldingOptionButtons[3] setSelected:YES];
            }else {
                [self.shieldingOptionButtons[3] setSelected:NO];
            }
            if (danmakuUserDefaults.shieldingOption & DdDanmakuShieldingColorful) {
                [self.shieldingOptionButtons[4] setSelected:YES];
            }else {
                [self.shieldingOptionButtons[4] setSelected:NO];
            }
            self.screenMaxlimitSlider.value = danmakuUserDefaults.screenMaxlimit;
            self.speedSlider.value = danmakuUserDefaults.speed;
            self.opacitySlider.value = danmakuUserDefaults.opacity;
            if (self.screenMaxlimitSlider.value == self.screenMaxlimitSlider.maximumValue) {
                self.screenMaxlimitLabel.text = @"不限制";
            }else {
                self.screenMaxlimitLabel.text = [NSString stringWithFormat:@"%lu条", danmakuUserDefaults.screenMaxlimit];
            }
            self.speedLabel.text = [NSString stringWithFormat:@"%.1f秒", danmakuUserDefaults.speed];
            self.opacityLabel.text = [NSString stringWithFormat:@"%li%%", (NSInteger)(danmakuUserDefaults.opacity * 100)];
            self.settingEffectView.left = self.settingView.width;
            [UIView animateWithDuration:0.25 animations:^{
                self.settingEffectView.left = self.settingView.width - self.settingEffectView.width;
            } completion:^(BOOL finished) {
                self.pan.enabled = NO;
            }];
        }];
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
#pragma mark Action - 投币
        [[coinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            BSAlertView *alertView = [[BSAlertView alloc] initWithTitle:@"提示" message:@"这将会消耗您一枚硬币，继续么？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"继续"] onButtonTouchUpInside:^(BSAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
            }];
            [alertView show];
        }];
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
        
        UIButton *entryDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        entryDanmakuBtn.adjustsImageWhenHighlighted = NO;
        [entryDanmakuBtn setImage:[UIImage imageNamed:@"icmpv_add_danmaku_light"] forState:UIControlStateNormal];
#pragma mark Action - 显示弹幕输入视图
        [[entryDanmakuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hide];
            [self showDanmakuEntryView];
            self.pan.enabled = NO;
        }];
        [bottomEffectView.contentView addSubview:entryDanmakuBtn];
        [entryDanmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomEffectView.contentView.mas_top);
            make.bottom.equalTo(bottomEffectView.contentView.mas_bottom);
            make.left.equalTo(bottomEffectView.contentView.mas_left);
            make.width.mas_equalTo(39.0);
        }];
        entryDanmakuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        entryDanmakuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
        
        UIButton *hideDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hideDanmakuBtn.adjustsImageWhenHighlighted = NO;
        [hideDanmakuBtn setImage:[UIImage imageNamed:@"icmpv_toggle_danmaku_hided_light"] forState:UIControlStateNormal];
        [hideDanmakuBtn setImage:[UIImage imageNamed:@"icmpv_toggle_danmaku_showed_light"] forState:UIControlStateSelected];
#pragma mark Action - 隐藏/显示弹幕
        [[hideDanmakuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            @strongify(self);
            x.selected = !x.isSelected;
            self.danmakuVM.shouldHideDanmakus = x.isSelected;
        }];
        [bottomEffectView.contentView addSubview:hideDanmakuBtn];
        [hideDanmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(entryDanmakuBtn.mas_right);
            make.top.equalTo(entryDanmakuBtn.mas_top);
            make.bottom.equalTo(entryDanmakuBtn.mas_bottom);
            make.width.mas_equalTo(45.0);
        }];
        hideDanmakuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        hideDanmakuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        
        UIButton *screenOrientationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        screenOrientationBtn.adjustsImageWhenHighlighted = NO;
        [screenOrientationBtn setImage:[UIImage imageNamed:@"player_window_iphone"] forState:UIControlStateNormal];
        screenOrientationBtn.rac_command = self.handleFullScreenCommand;
        [bottomEffectView.contentView addSubview:screenOrientationBtn];
        [screenOrientationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomEffectView.contentView.mas_right);
            make.top.equalTo(entryDanmakuBtn.mas_top);
            make.bottom.equalTo(entryDanmakuBtn.mas_bottom);
            make.width.mas_equalTo(39.0);
        }];
        screenOrientationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        screenOrientationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        
        UIButton *lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lockBtn.adjustsImageWhenHighlighted = NO;
        [lockBtn setImage:[UIImage imageNamed:@"player_lock"] forState:UIControlStateNormal];
#pragma mark Action - 显示锁屏视图
        [[lockBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hide];
            [self addSubview:self.lockView];
            self.isLocked = YES;
            for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
                recognizer.enabled = NO;
            }
        }];
        [bottomEffectView.contentView addSubview:lockBtn];
        [lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(screenOrientationBtn.mas_left);
            make.top.equalTo(entryDanmakuBtn.mas_top);
            make.bottom.equalTo(entryDanmakuBtn.mas_bottom);
            make.width.mas_equalTo(34.0);
        }];
        lockBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        lockBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 13);
        
        UIButton *chapterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chapterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [chapterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chapterBtn setTitle:@"选集" forState:UIControlStateNormal];
        [bottomEffectView.contentView addSubview:chapterBtn];
        [chapterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lockBtn.mas_left).offset(-11.0);
            make.top.equalTo(entryDanmakuBtn.mas_top);
            make.bottom.equalTo(entryDanmakuBtn.mas_bottom);
        }];
        UIButton *qualityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qualityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qualityBtn setTitle:@"流畅" forState:UIControlStateNormal];
        [bottomEffectView.contentView addSubview:qualityBtn];
        [qualityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(chapterBtn.mas_left).offset(-14.0);
            make.top.equalTo(entryDanmakuBtn.mas_top);
            make.bottom.equalTo(entryDanmakuBtn.mas_bottom);
        }];
        
        UISlider *mediaProgressSlider = [[UISlider alloc] init];
        _mediaProgressSlider = mediaProgressSlider;
        mediaProgressSlider.minimumTrackTintColor = kThemeColor;
        mediaProgressSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [mediaProgressSlider setThumbImage:[UIImage imageNamed:@"player_slider_thumb"] forState:UIControlStateNormal];
        [mediaProgressSlider addTarget:self action:@selector(handleDragSlider:) forControlEvents:UIControlEventValueChanged];
        [bottomEffectView.contentView addSubview:mediaProgressSlider];
        CGFloat sliderWidth = widthEx(208.0);
        if (kScreenHeight == kIphone_4s_Height) {
            sliderWidth -= kIphone_5_Height - kIphone_4s_Height;
        }
        [mediaProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(sliderWidth);
            make.centerX.equalTo(bottomEffectView.contentView.mas_centerX).offset(-44.0);
            make.centerY.equalTo(entryDanmakuBtn.mas_centerY);
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
        _backgroundMusicBtn = backgroundMusicBtn;
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
            DdPlayUserDefaults *playUserDefaults = [DdPlayUserDefaults sharedInstance];
            playUserDefaults.activeBackgroundPlayback = button.selected;
            [self.delegatePlayer setPauseInBackground:!playUserDefaults.activeBackgroundPlayback];
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

- (UIView *)settingView
{
    if (!_settingView) {
        UIView *settingView = [[UIView alloc] initWithFrame:self.bounds];
        _settingView = settingView;
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [UIView animateWithDuration:0.25 animations:^{
                self.settingEffectView.left = self.settingView.right;
            } completion:^(BOOL finished) {
                [self.settingView removeFromSuperview];
                self.pan.enabled = YES;
            }];
        }];
        [settingView addGestureRecognizer:tap];
        
        UIVisualEffectView *settingEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _settingEffectView = settingEffectView;
        settingEffectView.width = 274.0;
        settingEffectView.height = settingView.height;
        settingEffectView.top = 0.0;
        settingEffectView.left = settingView.width - settingEffectView.width;
        [settingView addSubview:settingEffectView];

        UILabel *shieldingLabel = [[UILabel alloc] init];
        shieldingLabel.font = [UIFont systemFontOfSize:14];
        shieldingLabel.textColor = [UIColor whiteColor];
        shieldingLabel.text = @"弹幕屏蔽";
        [settingEffectView.contentView addSubview:shieldingLabel];
        [shieldingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(settingEffectView.contentView.mas_top).offset(16.0);
            make.left.equalTo(settingEffectView.contentView.mas_left).offset(16.0);
        }];
        
        NSArray *shieldingTitles = @[@"顶部", @"滚动", @"底部", @"游客", @"彩色"];
        NSArray *shieldingImages = @[@"player_input_topbarrage_default_icon", @"player_input_bottombarrage_default_icon", @"player_input_rollbarrage_default_icon", @"player_input_tourist_default_icon", @"player_input_color_default_icon"];
        NSArray *shieldingSelectedImages = @[@"player_input_topbarrage_icon", @"player_input_bottombarrage_icon", @"player_input_rollbarrage_icon", @"player_input_tourist_icon", @"player_input_color_icon"];
        UIView *shieldingView = [[UIView alloc] init];
        [settingEffectView.contentView addSubview:shieldingView];
        CGFloat shieldingViewWidth = settingEffectView.width - 16.0 - 32.0;
        CGFloat shieldingViewHeight = 42.0;
        [shieldingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shieldingLabel.mas_left);
            make.top.equalTo(shieldingLabel.mas_bottom).offset(20.0);
            make.width.mas_equalTo(shieldingViewWidth);
            make.height.mas_equalTo(shieldingViewHeight);
        }];
        
        CGFloat shieldingItemWidth = 32.0;
        CGFloat shieldingItemInset = (shieldingViewWidth - shieldingItemWidth * shieldingTitles.count) / (shieldingTitles.count - 1);
        NSMutableArray *shieldingOptionButtons = [[NSMutableArray alloc] init];
        DdDanmakuUserDefaults *danmakuUserDefaults = [DdDanmakuUserDefaults sharedInstance];
        for (NSInteger i = 0; i < shieldingTitles.count; i++) {
            BSCentralButton *button = [BSCentralButton buttonWithType:UIButtonTypeCustom andContentSpace:4.0];
            [button setImage:[UIImage imageNamed:shieldingImages[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:shieldingSelectedImages[i]] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:kThemeColor forState:UIControlStateSelected];
            [button setTitle:shieldingTitles[i] forState:UIControlStateNormal];
#pragma mark Action - 弹幕屏蔽
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                x.selected = !x.isSelected;
                switch (i) {
                    case 0:
                        if (x.isSelected) {
                            danmakuUserDefaults.shieldingOption |= DdDanmakuShieldingFloatTop;
                        }else {
                            danmakuUserDefaults.shieldingOption ^= DdDanmakuShieldingFloatTop;
                        }
                        break;
                    case 1:
                        if (x.isSelected) {
                            danmakuUserDefaults.shieldingOption |= DdDanmakuShieldingWalk;
                        }else {
                            danmakuUserDefaults.shieldingOption ^= DdDanmakuShieldingWalk;
                        }
                        break;
                    case 2:
                        if (x.isSelected) {
                            danmakuUserDefaults.shieldingOption |= DdDanmakuShieldingFloatBottom;
                        }else {
                            danmakuUserDefaults.shieldingOption ^= DdDanmakuShieldingFloatBottom;
                        }
                        break;
                    case 3:
                        if (x.isSelected) {
                            danmakuUserDefaults.shieldingOption |= DdDanmakuShieldingVisitor;
                        }else {
                            danmakuUserDefaults.shieldingOption ^= DdDanmakuShieldingVisitor;
                        }
                        break;
                    case 4:
                        if (x.isSelected) {
                            danmakuUserDefaults.shieldingOption |= DdDanmakuShieldingColorful;
                        }else {
                            danmakuUserDefaults.shieldingOption ^= DdDanmakuShieldingColorful;
                        }
                        break;
                    default:
                        break;
                }
            }];
            button.frame = CGRectMake(i * (shieldingItemWidth + shieldingItemInset), 0, shieldingItemWidth, shieldingViewHeight);
            [shieldingOptionButtons addObject:button];
            [shieldingView addSubview:button];
        }
        _shieldingOptionButtons = shieldingOptionButtons;
        
        UILabel *opacityLabel = [[UILabel alloc] init];
        _opacityLabel = opacityLabel;
        opacityLabel.font = [UIFont systemFontOfSize:14];
        opacityLabel.textColor = [UIColor whiteColor];
        [settingEffectView.contentView addSubview:opacityLabel];
        [opacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(settingEffectView.contentView.mas_right).offset(-60.0);
            make.bottom.equalTo(settingEffectView.contentView.mas_bottom).offset(-16.0);
        }];
        UISlider *opacitySlider = [[UISlider alloc] init];
        _opacitySlider = opacitySlider;
        opacitySlider.thumbTintColor = [UIColor whiteColor];
        opacitySlider.minimumTrackTintColor = kThemeColor;
        opacitySlider.maximumTrackTintColor = [UIColor lightGrayColor];
#pragma mark Action - 弹幕透明度调整
        [[opacitySlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *x) {
            danmakuUserDefaults.opacity = x.value;
            opacityLabel.text = [NSString stringWithFormat:@"%li%%", (NSInteger)(danmakuUserDefaults.opacity * 100)];
        }];
        [settingEffectView.contentView addSubview:opacitySlider];
        [opacitySlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shieldingLabel.mas_left);
            make.right.equalTo(opacityLabel.mas_left).offset(-24.0);
            make.centerY.equalTo(opacityLabel.mas_centerY);
        }];
        UILabel *opacityTitleLabel = [[UILabel alloc] init];
        opacityTitleLabel.font = [UIFont systemFontOfSize:14];
        opacityTitleLabel.textColor = [UIColor whiteColor];
        opacityTitleLabel.text = @"弹幕透明度";
        [settingEffectView.contentView addSubview:opacityTitleLabel];
        [opacityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacitySlider.mas_left);
            make.bottom.equalTo(opacityLabel.mas_top).offset(-16.0);
        }];
        
        UILabel *speedLabel = [[UILabel alloc] init];
        _speedLabel = speedLabel;
        speedLabel.font = [UIFont systemFontOfSize:14];
        speedLabel.textColor = [UIColor whiteColor];
        [settingEffectView.contentView addSubview:speedLabel];
        [speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityLabel.mas_left);
            make.bottom.equalTo(opacityTitleLabel.mas_top).offset(-16.0);
        }];
        UISlider *speedSlider = [[UISlider alloc] init];
        _speedSlider = speedSlider;
        speedSlider.thumbTintColor = [UIColor whiteColor];
        speedSlider.minimumTrackTintColor = kThemeColor;
        speedSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        speedSlider.minimumValue = 4.0;
        speedSlider.maximumValue = 10.0;
#pragma mark Action - 弹幕速度调整
        [[speedSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *x) {
            danmakuUserDefaults.speed = x.value;
            speedLabel.text = [NSString stringWithFormat:@"%.1f秒", danmakuUserDefaults.speed];
        }];
        [settingEffectView.contentView addSubview:speedSlider];
        [speedSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacitySlider.mas_left);
            make.right.equalTo(speedLabel.mas_left).offset(-24.0);
            make.centerY.equalTo(speedLabel.mas_centerY);
        }];
        UILabel *speedTitleLabel = [[UILabel alloc] init];
        speedTitleLabel.font = [UIFont systemFontOfSize:14];
        speedTitleLabel.textColor = [UIColor whiteColor];
        speedTitleLabel.text = @"弹幕速度";
        [settingEffectView.contentView addSubview:speedTitleLabel];
        [speedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityTitleLabel.mas_left);
            make.bottom.equalTo(speedLabel.mas_top).offset(-16.0);
        }];
        
        UILabel *screenMaxlimitLabel = [[UILabel alloc] init];
        _screenMaxlimitLabel = screenMaxlimitLabel;
        screenMaxlimitLabel.font = [UIFont systemFontOfSize:14];
        screenMaxlimitLabel.textColor = [UIColor whiteColor];
        [settingEffectView.contentView addSubview:screenMaxlimitLabel];
        [screenMaxlimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityLabel.mas_left);
            make.bottom.equalTo(speedTitleLabel.mas_top).offset(-16.0);
        }];
        UISlider *screenMaxlimitSlider = [[UISlider alloc] init];
        _screenMaxlimitSlider = screenMaxlimitSlider;
        screenMaxlimitSlider.thumbTintColor = [UIColor whiteColor];
        screenMaxlimitSlider.minimumTrackTintColor = kThemeColor;
        screenMaxlimitSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        screenMaxlimitSlider.minimumValue = 0.0;
        screenMaxlimitSlider.maximumValue = 81.0;
#pragma mark Action - 同屏最大弹幕数调整
        [[screenMaxlimitSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *x) {
            if (x.value == x.maximumValue) {
                danmakuUserDefaults.screenMaxlimit = NSUIntegerMax;
                screenMaxlimitLabel.text = @"不限制";
            }else {
                danmakuUserDefaults.screenMaxlimit = x.value;
                screenMaxlimitLabel.text = [NSString stringWithFormat:@"%lu条", danmakuUserDefaults.screenMaxlimit];
            }
        }];
        [settingEffectView.contentView addSubview:screenMaxlimitSlider];
        [screenMaxlimitSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacitySlider.mas_left);
            make.right.equalTo(screenMaxlimitLabel.mas_left).offset(-24.0);
            make.centerY.equalTo(screenMaxlimitLabel.mas_centerY);
        }];
        UILabel *screenMaxlimitTitleLabel = [[UILabel alloc] init];
        screenMaxlimitTitleLabel.font = [UIFont systemFontOfSize:14];
        screenMaxlimitTitleLabel.textColor = [UIColor whiteColor];
        screenMaxlimitTitleLabel.text = @"同屏最大弹幕数";
        [settingEffectView.contentView addSubview:screenMaxlimitTitleLabel];
        [screenMaxlimitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityTitleLabel.mas_left);
            make.bottom.equalTo(screenMaxlimitLabel.mas_top).offset(-16.0);
        }];
    }
    return _settingView;
}

- (UIView *)danmakuEntryView
{
    if (!_danmakuEntryView) {
        UIView *danmakuEntryView = [[UIView alloc] initWithFrame:self.bounds];
        _danmakuEntryView = danmakuEntryView;
        @weakify(self);
#pragma mark Action - 取消输入
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [self cancelDanmakuEntryed];
        }];
        [danmakuEntryView addGestureRecognizer:tap];
        
        UIVisualEffectView *danmakuEntryEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        danmakuEntryEffectView.frame = danmakuEntryView.bounds;
        [danmakuEntryView addSubview:danmakuEntryEffectView];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.adjustsImageWhenHighlighted = NO;
        [cancelBtn setImage:[UIImage imageNamed:@"icmpv_back_light"] forState:UIControlStateNormal];
#pragma mark Action - 取消输入
        [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self cancelDanmakuEntryed];
        }];
        [danmakuEntryEffectView.contentView addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(danmakuEntryEffectView.contentView.mas_top).offset(10.0);
            make.left.equalTo(danmakuEntryEffectView.contentView.mas_left).offset(10.0);
        }];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
#pragma mark Action - 发送弹幕
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self sendDanmaku];
        }];
        [danmakuEntryEffectView.contentView addSubview:sendBtn];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(danmakuEntryEffectView.contentView.mas_right).offset(-12.0);
            make.centerY.equalTo(cancelBtn.mas_centerY);
        }];
        
        UITextField *danmakuTextField = [[UITextField alloc] init];
        _danmakuTextField = danmakuTextField;
        danmakuTextField.delegate = self;
        danmakuTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        danmakuTextField.layer.cornerRadius = 5.0;
        danmakuTextField.layer.masksToBounds = YES;
        danmakuTextField.tintColor = kThemeColor;
        danmakuTextField.font = [UIFont boldSystemFontOfSize:15];
        danmakuTextField.textColor = kTextColor;
        danmakuTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        danmakuTextField.returnKeyType = UIReturnKeySend;
        [danmakuEntryEffectView.contentView addSubview:danmakuTextField];
        [danmakuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cancelBtn.mas_right).offset(12.0);
            make.right.equalTo(sendBtn.mas_left).offset(-12.0);
            make.centerY.equalTo(cancelBtn.mas_centerY);
            make.height.mas_equalTo(28.0);
        }];
        [danmakuTextField setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
        
        DdDanmakuUserDefaults *danmakuUserDefaults = [DdDanmakuUserDefaults sharedInstance];
        CGFloat itemWidth = 36.0;
        CGFloat itemHeight = 25.0;
        UIView *preferredView = [[UIView alloc] init];
        [danmakuEntryEffectView.contentView addSubview:preferredView];
        [preferredView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(danmakuTextField.mas_left).offset(4.0);
            make.right.equalTo(danmakuTextField.mas_right).offset(-4.0);
            make.top.equalTo(danmakuTextField.mas_bottom).offset(12.0);
            make.height.mas_equalTo(itemHeight);
        }];
        
        NSArray *fontSizeImages = @[@"player_input_smalltype_default_icon", @"player_input_smalltype_default_icon"];
        NSArray *fontSizeSelectedImages = @[@"player_input_smalltype_icon", @"player_input_smalltype_icon"];
        NSMutableArray *fontSizeButtons = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < fontSizeImages.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = NO;
            [button setImage:[UIImage imageNamed:fontSizeImages[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:fontSizeSelectedImages[i]] forState:UIControlStateSelected];
            button.frame = CGRectMake(i * (itemWidth + 10), 0, itemWidth, itemHeight);
            button.tag = fontSizes[i];
#pragma mark Action - 设置字体大小
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                @strongify(self);
                for (UIButton *btn in self.fontSizeButtons) {
                    btn.selected = NO;
                }
                x.selected = YES;
                danmakuUserDefaults.preferredFontSize = x.tag;
            }];
            [preferredView addSubview:button];
            [fontSizeButtons addObject:button];
        }
        _fontSizeButtons = fontSizeButtons;
        
        NSArray *styleImages = @[@"player_input_topbarrage_default_icon", @"player_input_rollbarrage_default_icon", @"player_input_bottombarrage_default_icon"];
        NSArray *styleSelectedImages = @[@"player_input_topbarrage_icon", @"player_input_rollbarrage_icon", @"player_input_bottombarrage_icon"];
        NSMutableArray *styleButtons = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < styleImages.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = NO;
            [button setImage:[UIImage imageNamed:styleImages[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:styleSelectedImages[i]] forState:UIControlStateSelected];
            button.frame = CGRectMake(itemWidth * fontSizeButtons.count + 10 * (fontSizeButtons.count - 1) + 32 + i * (itemWidth + 10), 0, itemWidth, itemHeight);
            button.tag = styles[i];
#pragma mark Action - 设置弹幕样式
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                @strongify(self);
                for (UIButton *btn in self.styleButtons) {
                    btn.selected = NO;
                }
                x.selected = YES;
                danmakuUserDefaults.preferredStyle = x.tag;
            }];
            [preferredView addSubview:button];
            [styleButtons addObject:button];
        }
        _styleButtons = styleButtons;
        
        UIButton *textColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textColorButton = textColorButton;
        textColorButton.adjustsImageWhenHighlighted = NO;
        textColorButton.frame = CGRectMake(itemWidth * (fontSizeButtons.count + styleButtons.count) + 10 * (fontSizeButtons.count + styleButtons.count - 2) + 32 * 2, 0, itemWidth, itemHeight);
        textColorButton.layer.cornerRadius = 8.0;
        textColorButton.layer.masksToBounds = YES;
        textColorButton.layer.borderColor = kThemeColor.CGColor;
        textColorButton.layer.borderWidth = 2.0;
#pragma mark Action - 设置字体颜色
        [[textColorButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            
        }];
        [preferredView addSubview:textColorButton];
    }
    return _danmakuEntryView;
}

- (UIControl *)lockView
{
    if (!_lockView) {
        UIControl *lockView = [[UIControl alloc] initWithFrame:self.bounds];
        _lockView = lockView;
#pragma mark Action - 显示锁屏内容视图
        @weakify(self);
        [[lockView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self showLockContentView];
        }];
        
        UIControl *lockContentView = [[UIControl alloc] initWithFrame:lockView.bounds];
        _lockContentView = lockContentView;
#pragma mark Action - 隐藏锁屏内容视图
        [[lockContentView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hideLockContentView];
        }];
        [lockView addSubview:lockContentView];
        
        UIButton *sendDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendDanmakuBtn.adjustsImageWhenHighlighted = NO;
        [sendDanmakuBtn setImage:[UIImage imageNamed:@"player_lock_commt"] forState:UIControlStateNormal];
#pragma mark Action - 锁屏状态发送弹幕
        [[sendDanmakuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hideLockContentView];
            [self showDanmakuEntryView];
        }];
        [lockContentView addSubview:sendDanmakuBtn];
        [sendDanmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lockContentView.mas_centerY).offset(-10.0);
            make.right.equalTo(lockContentView.mas_right).offset(-10.0);
        }];
        
        UIButton *unlockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        unlockBtn.adjustsImageWhenHighlighted = NO;
        [unlockBtn setImage:[UIImage imageNamed:@"player_unlock"] forState:UIControlStateNormal];
#pragma mark Action - 移除锁屏视图
        [[unlockBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.lockView removeFromSuperview];
            self.isLocked = NO;
            [self cancelLockContentViewDelayedHide];
            [self showAndFade];
            for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
                recognizer.enabled = YES;
            }
        }];
        [lockContentView addSubview:unlockBtn];
        [unlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lockContentView.mas_centerY).offset(10.0);
            make.right.equalTo(lockContentView.mas_right).offset(-10.0);
        }];
    }
    return _lockView;
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

#pragma mark 显示弹幕输入视图
- (void)showDanmakuEntryView
{
    [self.delegatePlayer pause];
    [self addSubview:self.danmakuEntryView];
    DdDanmakuUserDefaults *danmakuUserDefaults = [DdDanmakuUserDefaults sharedInstance];
    for (UIButton *button in self.fontSizeButtons) {
        if (button.tag == danmakuUserDefaults.preferredFontSize) {
            button.selected = YES;
        }else {
            button.selected = NO;
        }
    }
    
    for (UIButton *button in self.styleButtons) {
        if (button.tag == danmakuUserDefaults.preferredStyle) {
            button.selected = YES;
        }else {
            button.selected = NO;
        }
    }
    
    [self.textColorButton setImage:[UIImage imageWithColor:danmakuUserDefaults.preferredTextColor size:self.textColorButton.size]   forState:UIControlStateNormal];
    self.danmakuTextField.text = nil;
    [self.danmakuTextField becomeFirstResponder];
}

#pragma mark 取消弹幕输入
- (void)cancelDanmakuEntryed
{
    [self.danmakuTextField resignFirstResponder];
    [self.danmakuEntryView removeFromSuperview];
    [self.delegatePlayer play];
    if (!self.isLocked) {
        self.pan.enabled = YES;
    }
}

#pragma mark 发送弹幕
- (void)sendDanmaku
{
    [self cancelDanmakuEntryed];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.danmakuVM.renderer receive:[[DdDanmakuUserDefaults sharedInstance] preferredDanmakuDescriptorWithText:self.danmakuTextField.text]];
    });
}

#pragma mark 显示锁定内容视图
- (void)showLockContentView
{
    [self cancelLockContentViewDelayedHide];
    self.lockContentView.hidden = NO;
    self.lockContentView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.lockContentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideLockContentView) withObject:nil afterDelay:5.0];
    }];
}

#pragma mark 隐藏锁定内容视图
- (void)hideLockContentView
{
    self.lockContentView.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.lockContentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.lockContentView.hidden = YES;
    }];
    
    [self cancelLockContentViewDelayedHide];
}

#pragma mark 取消锁定内容视图延迟隐藏命令
- (void)cancelLockContentViewDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLockContentView) object:nil];
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

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendDanmaku];
    return YES;
}

@end
