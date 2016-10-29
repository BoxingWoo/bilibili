//
//  LiveLandscapeMediaControl.m
//  Dilidili
//
//  Created by iMac on 2016/10/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveLandscapeMediaControl.h"
#import <AVFoundation/AVFoundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "DdDanmakuViewController.h"
#import "BSCentralButton.h"
#import "BSAlertView.h"
#import "DdProgressHUD.h"
#import "DdBrightnessView.h"
#import <pop/POP.h>

@interface LiveLandscapeMediaControl () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isVerticalMoved;  //是否垂直移动
    BOOL _isVolumeAdjusted;  //是否调节音量
}

#pragma mark 控制面板

@property (nonatomic, weak) UITapGestureRecognizer *playbackTap;  //播放控制点击手势
@property (nonatomic, weak) UIPanGestureRecognizer *pan;  //平移手势，用来控制音量、亮度

/** 播放控制面板 */
@property (nonatomic, weak) UIView *playbackControlPanel;
/** 系统音量滑块 */
@property (nonatomic, strong) UISlider *systemVolumeSlider;

#pragma mark 弹幕输入

/** 弹幕输入视图 */
@property (nonatomic, strong) UIView *danmakuEntryView;
/** 弹幕输入内容视图 */
@property (nonatomic, weak) UIView *danmakuEntryContentView;
/** 弹幕输入框 */
@property (nonatomic, weak) UITextField *danmakuTextField;
/** 弹幕字体颜色按钮数组 */
@property (nonatomic, copy) NSArray <UIButton *> *textColorButtons;

#pragma mark 热门关键词

/** 热门关键词视图 */
@property (nonatomic, strong) UIView *hotWordView;
/** 热门关键词内容视图 */
@property (nonatomic, weak) UIVisualEffectView *hotWordEffectView;
/** 热门关键词表视图 */
@property (nonatomic, weak) UITableView *hotWordTableView;

#pragma mark 弹幕设置

/** 设置视图 */
@property (nonatomic, strong) UIView *settingView;
/** 设置内容视图 */
@property (nonatomic, weak) UIVisualEffectView *settingEffectView;
/** 显示弹幕开关 */
@property (nonatomic, weak) UISwitch *showDanmakuSwitch;
/** 同屏最大弹幕数滑块 */
@property (nonatomic, weak) UISlider *screenMaxlimitSlider;
/** 速度滑块 */
@property (nonatomic, weak) UISlider *speedSlider;
/** 透明度滑块 */
@property (nonatomic, weak) UISlider *opacitySlider;
/** 描边宽度滑块 */
@property (nonatomic, weak) UISlider *strokeWidthSlider;
/** 同屏最大弹幕数标签 */
@property (nonatomic, weak) UILabel *screenMaxlimitLabel;
/** 速度标签 */
@property (nonatomic, weak) UILabel *speedLabel;
/** 透明度标签 */
@property (nonatomic, weak) UILabel *opacityLabel;
/** 描边宽度标签 */
@property (nonatomic, weak) UILabel *strokeWidthLabel;

@end

@implementation LiveLandscapeMediaControl

static NSString *const khotWordCellId = @"HotWordCell";

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
        
        //播放/暂停
        UITapGestureRecognizer *playbackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePlayback:)];
        _playbackTap = playbackTap;
        playbackTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:playbackTap];
        
        //显示播放控制面板
        UITapGestureRecognizer *showTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAndFade)];
        [showTap requireGestureRecognizerToFail:playbackTap];
        [self addGestureRecognizer:showTap];
        
        //平移手势，用来控制音量、亮度
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
        
        UIImage *shadeImage = [UIImage imageNamed:@"live_shade_bg"];
        UIView *topView = [[UIView alloc] init];
        [playbackControlPanel addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(playbackControlPanel);
            make.height.mas_equalTo(60.0);
        }];
        
        UIImageView *topImageView = [[UIImageView alloc] initWithImage:[shadeImage imageByFlipVertical]];
        [topView addSubview:topImageView];
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.adjustsImageWhenHighlighted = NO;
        [backBtn setImage:[UIImage imageNamed:@"live_back_ico"] forState:UIControlStateNormal];
        backBtn.rac_command = self.handleBackCommand;
        [playbackControlPanel addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(playbackControlPanel.mas_top).offset(24.0);
            make.left.equalTo(playbackControlPanel.mas_left).offset(8.0);
        }];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.adjustsImageWhenHighlighted = NO;
        [moreBtn setImage:[UIImage imageNamed:@"live_share_ico"] forState:UIControlStateNormal];
        moreBtn.rac_command = self.handleMoreCommand;
        [topView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topView.mas_right).offset(-8.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        
        UIButton *roomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        roomBtn.userInteractionEnabled = NO;
        roomBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [roomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [roomBtn setTitle:[NSString stringWithFormat:@"%li", self.model.room_id] forState:UIControlStateNormal];
        [roomBtn setImage:[UIImage imageNamed:@"live_room_ico"] forState:UIControlStateNormal];
        [topView addSubview:roomBtn];
        [roomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topView.mas_centerX).offset(-4.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        
        UIButton *onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        onlineBtn.userInteractionEnabled = NO;
        onlineBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [onlineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [onlineBtn setTitle:[DdFormatter stringForCount:self.model.online] forState:UIControlStateNormal];
        [onlineBtn setImage:[UIImage imageNamed:@"live_online_ico"] forState:UIControlStateNormal];
        [topView addSubview:onlineBtn];
        [onlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView.mas_centerX).offset(4.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = self.model.title;
        [topView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backBtn.mas_right).offset(8.0);
            make.right.equalTo(roomBtn.mas_left).offset(-8.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        [titleLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
        [titleLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
        
        UIView *bottomView = [[UIView alloc] init];
        [playbackControlPanel addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(playbackControlPanel);
            make.height.mas_equalTo(52.0);
        }];
        UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:shadeImage];
        [bottomView addSubview:bottomImageView];
        [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        @weakify(self);
        UIButton *entryDanmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        entryDanmakuBtn.adjustsImageWhenHighlighted = NO;
        [entryDanmakuBtn setImage:[UIImage imageNamed:@"live_danmaku_ico"] forState:UIControlStateNormal];
#pragma mark Action - 显示弹幕输入视图
        [[entryDanmakuBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hide];
            [self addSubview:self.danmakuEntryView];
            for (NSInteger i = 0; i < self.textColorButtons.count; i++) {
                UIButton *button = self.textColorButtons[i];
                button.selected = NO;
                button.enabled = NO;
                if (i != 0) {
                    button.enabled = NO;
                }else {
                    button.enabled = YES;
                    button.selected = YES;
                }
            }
            self.danmakuTextField.text = nil;
            [self.danmakuTextField becomeFirstResponder];
            self.pan.enabled = NO;
        }];
        [bottomView addSubview:entryDanmakuBtn];
        [entryDanmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomView.mas_bottom).offset(-8.0);
            make.left.equalTo(bottomView.mas_left).offset(10.0);
        }];
        
        UIButton *hotWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hotWordBtn.adjustsImageWhenHighlighted = NO;
        [hotWordBtn setImage:[UIImage imageNamed:@"live_hot_ico"] forState:UIControlStateNormal];
#pragma mark Action - 显示热门关键字视图
        [[hotWordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hide];
            [self addSubview:self.hotWordView];
            self.hotWordEffectView.right = 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.hotWordEffectView.left = 0;
            } completion:^(BOOL finished) {
                self.pan.enabled = NO;
            }];
        }];
        [bottomView addSubview:hotWordBtn];
        [hotWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(entryDanmakuBtn.mas_right).offset(18.0);
            make.centerY.equalTo(entryDanmakuBtn.mas_centerY);
        }];
        
        UIButton *screenOrientationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        screenOrientationBtn.adjustsImageWhenHighlighted = NO;
        [screenOrientationBtn setImage:[UIImage imageNamed:@"live_player_ico"] forState:UIControlStateNormal];
        screenOrientationBtn.rac_command = self.handleFullScreenCommand;
        [bottomView addSubview:screenOrientationBtn];
        [screenOrientationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomView.mas_right).offset(-12.0);
            make.centerY.equalTo(entryDanmakuBtn.mas_centerY);
        }];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.adjustsImageWhenHighlighted = NO;
        [settingBtn setImage:[UIImage imageNamed:@"live_danmukaSetting"] forState:UIControlStateNormal];
#pragma mark Action - 显示弹幕设置视图
        [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self hide];
            [self addSubview:self.settingView];
            DdDanmakuUserDefaults *danmakuUserDefaults = [DdDanmakuUserDefaults sharedInstance];
            self.showDanmakuSwitch.on = !self.dvc.shouldHideDanmakus;
            self.screenMaxlimitSlider.value = danmakuUserDefaults.screenMaxlimit;
            self.speedSlider.value = danmakuUserDefaults.speed;
            self.opacitySlider.value = danmakuUserDefaults.opacity;
            self.strokeWidthSlider.value = danmakuUserDefaults.strokeWidth;
            if (self.screenMaxlimitSlider.value == self.screenMaxlimitSlider.maximumValue) {
                self.screenMaxlimitLabel.text = @"不限制";
            }else {
                self.screenMaxlimitLabel.text = [NSString stringWithFormat:@"%lu条", danmakuUserDefaults.screenMaxlimit];
            }
            self.speedLabel.text = [NSString stringWithFormat:@"%.1f秒", danmakuUserDefaults.speed];
            self.opacityLabel.text = [NSString stringWithFormat:@"%li%%", (NSInteger)(danmakuUserDefaults.opacity * 100)];
            self.strokeWidthLabel.text = [NSString stringWithFormat:@"%.1fpx", danmakuUserDefaults.strokeWidth];
            self.settingEffectView.left = self.settingView.width;
            [UIView animateWithDuration:0.25 animations:^{
                self.settingEffectView.left = self.settingView.width - self.settingEffectView.width;
            } completion:^(BOOL finished) {
                self.pan.enabled = NO;
            }];
        }];
        [bottomView addSubview:settingBtn];
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(screenOrientationBtn.mas_left).offset(-16.0);
            make.centerY.equalTo(entryDanmakuBtn.mas_centerY);
        }];
        
        UIButton *chestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chestBtn.adjustsImageWhenHighlighted = NO;
        [chestBtn setImage:[UIImage imageNamed:@"live_boxopen_ico"] forState:UIControlStateNormal];
#pragma mark Action - 获取宝箱
        [[chestBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            BSAlertView *alertView = [[BSAlertView alloc] initWithTitle:nil message:@"天真- ( ゜- ゜)つロ 乾杯~ - bilibili" cancelButtonTitle:@"是在下输了" otherButtonTitles:nil onButtonTouchUpInside:NULL];
            alertView.tintColor = kThemeColor;
            [alertView show];
        }];
        [bottomView addSubview:chestBtn];
        [chestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(settingBtn.mas_left).offset(-16.0);
            make.centerY.equalTo(entryDanmakuBtn.mas_centerY);
        }];
        
        UIButton *giftEffectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        giftEffectBtn.adjustsImageWhenHighlighted = NO;
        [giftEffectBtn setImage:[UIImage imageNamed:@"live_special"] forState:UIControlStateNormal];
        [giftEffectBtn setImage:[UIImage imageNamed:@"live_special_shield"] forState:UIControlStateSelected];
#pragma mark Action - 打开/关闭礼物特效
        [[giftEffectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            x.selected = !x.isSelected;
            if (x.isSelected) {
                [DdProgressHUD showImage:nil status:@"已关闭礼物特效"];
            }else {
                [DdProgressHUD showImage:nil status:@"已开启礼物特效"];
            }
        }];
        [bottomView addSubview:giftEffectBtn];
        [giftEffectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(chestBtn.mas_left).offset(-16.0);
            make.centerY.equalTo(entryDanmakuBtn.mas_centerY);
        }];
        
        UIButton *giftGivingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        giftGivingBtn.adjustsImageWhenHighlighted = NO;
        [giftGivingBtn setImage:[UIImage imageNamed:@"live_gifts_ico"] forState:UIControlStateNormal];
#pragma mark Action - 赠送礼物
        [[giftGivingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            
        }];
        [bottomView addSubview:giftGivingBtn];
        [giftGivingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(giftEffectBtn.mas_left).offset(-16.0);
            make.centerY.equalTo(entryDanmakuBtn.mas_centerY);
        }];
        
    }
    return _playbackControlPanel;
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
            [self.danmakuTextField resignFirstResponder];
            [self.danmakuEntryView removeFromSuperview];
        }];
        [danmakuEntryView addGestureRecognizer:tap];
        
        UIView *danmakuEntryContentView = [[UIView alloc] init];
        _danmakuEntryContentView = danmakuEntryContentView;
        danmakuEntryContentView.width = danmakuEntryView.width;
        danmakuEntryContentView.height = 85.0;
        danmakuEntryContentView.left = 0.0;
        danmakuEntryContentView.top = danmakuEntryView.height;
        [danmakuEntryView addSubview:danmakuEntryContentView];
        
        UIView *danmakuTextView = [[UIView alloc] init];
        danmakuTextView.backgroundColor = [UIColor whiteColor];
        [danmakuEntryContentView addSubview:danmakuTextView];
        [danmakuTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(danmakuEntryContentView);
            make.height.mas_equalTo(49.0);
        }];
        CGFloat textFieldHeight = 32.0;
        UITextField *danmakuTextField = [[UITextField alloc] init];
        _danmakuTextField = danmakuTextField;
        danmakuTextField.delegate = self;
        danmakuTextField.backgroundColor = [UIColor colorWithWhite:239 / 255.0 alpha:1.0];
        danmakuTextField.layer.cornerRadius = textFieldHeight / 2;
        danmakuTextField.layer.masksToBounds = YES;
        danmakuEntryView.layer.borderColor = kBorderColor.CGColor;
        danmakuEntryView.layer.borderWidth = 1.0;
        danmakuTextField.tintColor = kThemeColor;
        danmakuTextField.font = [UIFont boldSystemFontOfSize:15];
        danmakuTextField.textColor = kTextColor;
        danmakuTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        danmakuTextField.returnKeyType = UIReturnKeySend;
        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldHeight / 2, textFieldHeight)];
        danmakuTextField.leftViewMode = UITextFieldViewModeAlways;
        danmakuTextField.leftView = emptyView;
        danmakuTextField.rightViewMode = UITextFieldViewModeAlways;
        danmakuTextField.rightView = emptyView;
        [danmakuTextView addSubview:danmakuTextField];
        [danmakuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(danmakuTextView.mas_left).offset(8.0);
            make.right.equalTo(danmakuTextView.mas_right).offset(-8.0);
            make.centerY.equalTo(danmakuTextView.mas_centerY);
            make.height.mas_equalTo(32.0);
        }];
        
        UIVisualEffectView *textColorEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [danmakuEntryContentView addSubview:textColorEffectView];
        [textColorEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(danmakuEntryContentView);
            make.bottom.equalTo(danmakuTextView.mas_top);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"弹幕色";
        [textColorEffectView.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textColorEffectView.contentView.mas_left).offset(10.0);
            make.centerY.equalTo(textColorEffectView.contentView.mas_centerY);
        }];
        
        NSArray *textColorImages = @[@"live_whiten_ico", @"live_redn_ico", @"live_bluen_ico", @"live_lightBluen_ico", @"live_greenn_ico", @"live_yellown_ico", @"live_brown_ico"];
        NSArray *textColorSelectedImages = @[@"live_whites_ico", @"live_reds_ico", @"live_blues_ico", @"live_lightBlues_ico", @"live_greens_ico", @"live_yellows_ico", @"live_brows_ico"];
        NSArray *textColorDisableImages = @[@"", @"live_redl_ico", @"live_bluel_ico", @"live_lightBluel_ico", @"live_greenl_ico", @"live_yellowl_ico", @"live_browl_ico"];
        CGFloat itemWidth = 30.0;
        CGFloat itemSpace = 8.0;
        CGFloat textColorViewWidth = textColorImages.count * (itemWidth + itemSpace) - itemSpace;
        UIView *textColorView = [[UIView alloc] init];
        [textColorEffectView.contentView addSubview:textColorView];
        [textColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(12.0);
            make.centerY.equalTo(textColorEffectView.contentView.mas_centerY);
            make.width.mas_equalTo(textColorViewWidth);
            make.height.mas_equalTo(itemWidth);
        }];
        
        NSMutableArray *textColorButtons = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < textColorImages.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = NO;
            button.adjustsImageWhenDisabled = NO;
            [button setImage:[UIImage imageNamed:textColorImages[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:textColorSelectedImages[i]] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:textColorDisableImages[i]] forState:UIControlStateDisabled];
            button.frame = CGRectMake(i * (itemWidth + itemSpace), 0, itemWidth, itemWidth);
#pragma mark Action - 设置弹幕颜色
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                @strongify(self);
                for (UIButton *btn in self.textColorButtons) {
                    btn.selected = NO;
                }
                x.selected = YES;
            }];
            [textColorView addSubview:button];
            [textColorButtons addObject:button];
        }
        _textColorButtons = textColorButtons;
    }
    return _danmakuEntryView;
}

- (UIView *)hotWordView
{
    if (!_hotWordView) {
        UIView *hotWordView = [[UIView alloc] initWithFrame:self.bounds];
        _hotWordView = hotWordView;
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [UIView animateWithDuration:0.25 animations:^{
                self.hotWordEffectView.right = 0;
            } completion:^(BOOL finished) {
                [self.hotWordView removeFromSuperview];
                self.pan.enabled = YES;
            }];
        }];
        [hotWordView addGestureRecognizer:tap];
        
        UIVisualEffectView *hotWordEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _hotWordEffectView = hotWordEffectView;
        hotWordEffectView.width = 160.0;
        hotWordEffectView.height = hotWordView.height;
        hotWordEffectView.top = 0.0;
        hotWordEffectView.left = 0.0;
        [hotWordView addSubview:hotWordEffectView];
        
        UITableView *hotWordTableView = [[UITableView alloc] initWithFrame:hotWordEffectView.contentView.bounds style:UITableViewStylePlain];
        _hotWordTableView = hotWordTableView;
        hotWordTableView.dataSource = self;
        hotWordTableView.delegate = self;
        hotWordTableView.backgroundColor = [UIColor clearColor];
        hotWordTableView.showsVerticalScrollIndicator = NO;
        hotWordTableView.showsHorizontalScrollIndicator = NO;
        hotWordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        hotWordTableView.rowHeight = 30.0;
        [hotWordEffectView.contentView addSubview:hotWordTableView];
    }
    return _hotWordView;
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
        
        UILabel *danmakuLabel = [[UILabel alloc] init];
        danmakuLabel.font = [UIFont systemFontOfSize:15];
        danmakuLabel.textColor = [UIColor whiteColor];
        danmakuLabel.text = @"弹幕";
        [settingEffectView.contentView addSubview:danmakuLabel];
        [danmakuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(settingEffectView.contentView.mas_top).offset(20.0);
            make.left.equalTo(settingEffectView.contentView.mas_left).offset(16.0);
        }];
        
        UISwitch *showDanmakuSwitch = [[UISwitch alloc] init];
        _showDanmakuSwitch = showDanmakuSwitch;
        showDanmakuSwitch.thumbTintColor = [UIColor whiteColor];
        showDanmakuSwitch.onTintColor = kThemeColor;
        showDanmakuSwitch.tintColor = [UIColor whiteColor];
        showDanmakuSwitch.offImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(51.0, 31.0)];
#pragma mark Action - 显示/关闭弹幕
        [[showDanmakuSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *x) {
            @strongify(self);
            self.dvc.shouldHideDanmakus = !x.isOn;
            if (x.isOn) {
                [DdProgressHUD showImage:nil status:@"已开启弹幕"];
            }else {
                [DdProgressHUD showImage:nil status:@"已关闭弹幕"];
            }
        }];
        [settingEffectView.contentView addSubview:showDanmakuSwitch];
        [showDanmakuSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(settingEffectView.contentView.mas_right).offset(-22.0);
            make.centerY.equalTo(danmakuLabel.mas_centerY);
        }];
        
        DdDanmakuUserDefaults *danmakuUserDefaults = [DdDanmakuUserDefaults sharedInstance];
        CGFloat space = -heightEx(16.0);
        
        UILabel *strokeWidthLabel = [[UILabel alloc] init];
        _strokeWidthLabel = strokeWidthLabel;
        strokeWidthLabel.font = [UIFont systemFontOfSize:15];
        strokeWidthLabel.textColor = [UIColor whiteColor];
        [settingEffectView.contentView addSubview:strokeWidthLabel];
        [strokeWidthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(settingEffectView.contentView.mas_right).offset(-60.0);
            make.bottom.equalTo(settingEffectView.contentView.mas_bottom).offset(space);
        }];
        UISlider *strokeWidthSlider = [[UISlider alloc] init];
        _strokeWidthSlider = strokeWidthSlider;
        strokeWidthSlider.thumbTintColor = [UIColor whiteColor];
        strokeWidthSlider.minimumTrackTintColor = kThemeColor;
        strokeWidthSlider.maximumTrackTintColor = [UIColor lightGrayColor];
        strokeWidthSlider.minimumValue = 0.0;
        strokeWidthSlider.maximumValue = 2.0;
#pragma mark Action - 弹幕描边宽度调整
        [[strokeWidthSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *x) {
            danmakuUserDefaults.strokeWidth = x.value;
            strokeWidthLabel.text = [NSString stringWithFormat:@"%.1fpx", danmakuUserDefaults.strokeWidth];
        }];
        [settingEffectView.contentView addSubview:strokeWidthSlider];
        [strokeWidthSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(danmakuLabel.mas_left);
            make.right.equalTo(strokeWidthLabel.mas_left).offset(-24.0);
            make.centerY.equalTo(strokeWidthLabel.mas_centerY);
        }];
        UILabel *strokeWidthTitleLabel = [[UILabel alloc] init];
        strokeWidthTitleLabel.font = [UIFont systemFontOfSize:15];
        strokeWidthTitleLabel.textColor = [UIColor whiteColor];
        strokeWidthTitleLabel.text = @"弹幕描边宽度";
        [settingEffectView.contentView addSubview:strokeWidthTitleLabel];
        [strokeWidthTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(strokeWidthSlider.mas_left);
            make.bottom.equalTo(strokeWidthLabel.mas_top).offset(space);
        }];
        
        UILabel *opacityLabel = [[UILabel alloc] init];
        _opacityLabel = opacityLabel;
        opacityLabel.font = [UIFont systemFontOfSize:15];
        opacityLabel.textColor = [UIColor whiteColor];
        [settingEffectView.contentView addSubview:opacityLabel];
        [opacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(settingEffectView.contentView.mas_right).offset(-60.0);
            make.bottom.equalTo(strokeWidthTitleLabel.mas_top).offset(space);
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
            make.left.equalTo(strokeWidthSlider.mas_left);
            make.right.equalTo(opacityLabel.mas_left).offset(-24.0);
            make.centerY.equalTo(opacityLabel.mas_centerY);
        }];
        UILabel *opacityTitleLabel = [[UILabel alloc] init];
        opacityTitleLabel.font = [UIFont systemFontOfSize:15];
        opacityTitleLabel.textColor = [UIColor whiteColor];
        opacityTitleLabel.text = @"弹幕透明度";
        [settingEffectView.contentView addSubview:opacityTitleLabel];
        [opacityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacitySlider.mas_left);
            make.bottom.equalTo(opacityLabel.mas_top).offset(space);
        }];
        
        UILabel *speedLabel = [[UILabel alloc] init];
        _speedLabel = speedLabel;
        speedLabel.font = [UIFont systemFontOfSize:15];
        speedLabel.textColor = [UIColor whiteColor];
        [settingEffectView.contentView addSubview:speedLabel];
        [speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityLabel.mas_left);
            make.bottom.equalTo(opacityTitleLabel.mas_top).offset(space);
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
            make.left.equalTo(strokeWidthSlider.mas_left);
            make.right.equalTo(speedLabel.mas_left).offset(-24.0);
            make.centerY.equalTo(speedLabel.mas_centerY);
        }];
        UILabel *speedTitleLabel = [[UILabel alloc] init];
        speedTitleLabel.font = [UIFont systemFontOfSize:15];
        speedTitleLabel.textColor = [UIColor whiteColor];
        speedTitleLabel.text = @"弹幕速度";
        [settingEffectView.contentView addSubview:speedTitleLabel];
        [speedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityTitleLabel.mas_left);
            make.bottom.equalTo(speedLabel.mas_top).offset(space);
        }];
        
        UILabel *screenMaxlimitLabel = [[UILabel alloc] init];
        _screenMaxlimitLabel = screenMaxlimitLabel;
        screenMaxlimitLabel.font = [UIFont systemFontOfSize:15];
        screenMaxlimitLabel.textColor = [UIColor whiteColor];
        [settingEffectView.contentView addSubview:screenMaxlimitLabel];
        [screenMaxlimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityLabel.mas_left);
            make.bottom.equalTo(speedTitleLabel.mas_top).offset(space);
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
            make.left.equalTo(strokeWidthSlider.mas_left);
            make.right.equalTo(screenMaxlimitLabel.mas_left).offset(-24.0);
            make.centerY.equalTo(screenMaxlimitLabel.mas_centerY);
        }];
        UILabel *screenMaxlimitTitleLabel = [[UILabel alloc] init];
        screenMaxlimitTitleLabel.font = [UIFont systemFontOfSize:15];
        screenMaxlimitTitleLabel.textColor = [UIColor whiteColor];
        screenMaxlimitTitleLabel.text = @"同屏最大弹幕数";
        [settingEffectView.contentView addSubview:screenMaxlimitTitleLabel];
        [screenMaxlimitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(opacityTitleLabel.mas_left);
            make.bottom.equalTo(screenMaxlimitLabel.mas_top).offset(space);
        }];
    }
    return _settingView;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.hot_word.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:khotWordCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:khotWordCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.width = tableView.width - 10.0 * 2;
        cell.textLabel.height = tableView.rowHeight;
        cell.textLabel.left = 10.0;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    LiveHotWordModel *model = self.model.hot_word[indexPath.row];
    cell.textLabel.text = model.words;
    return cell;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark 移除通知中心
- (void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_delegatePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_delegatePlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_delegatePlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dvc.renderer receive:[[DdDanmakuUserDefaults sharedInstance] preferredDanmakuDescriptorWithText:textField.text]];
    });
    [self.danmakuEntryView removeFromSuperview];
    return YES;
}

#pragma mark - KeyboardObserver

- (void)observeKeyboardWillShow:(NSNotification *)notification
{
    CGRect toFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    toFrame = [self.window convertRect:toFrame toView:self.danmakuEntryView];
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (animationDuration != 0) {
        UIViewAnimationOptions animationOptions = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        [UIView animateWithDuration:animationDuration delay:0 options:animationOptions | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.danmakuEntryContentView.bottom = toFrame.origin.y;
        } completion:NULL];
    }
}

#pragma mark 垂直移动
- (void)verticalMoved:(float)value
{
    _isVolumeAdjusted ? (self.systemVolumeSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
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
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (_isVerticalMoved) {
                [self verticalMoved:veloctyPoint.y];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
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
