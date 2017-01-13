//
//  DdMediaControl.m
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdMediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "DdPortraitMediaControl.h"
#import "DdLandscapeMediaControl.h"

@interface DdMediaControl ()

/** 加载控制面板 */
@property (nonatomic, weak) UIView *loadingControlPanel;
/** 加载描述标签 */
@property (nonatomic, weak) UILabel *detailLabel;
/** 竖屏控制器 */
@property (nonatomic, weak) DdPortraitMediaControl *portraitMediaControl;
/** 横屏控制器 */
@property (nonatomic, weak) DdLandscapeMediaControl *landscapeMediaControl;

@end

@implementation DdMediaControl

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        _statusBarHidden = NO;
        
        [self installMovieNotificationObservers];
    }
    return self;
}

- (void)dealloc
{
    DDLogWarn(@"%@ dealloc！", [self.class description]);
    [self removeMovieNotificationObservers];
    [_portraitMediaControl clean];
    [_landscapeMediaControl clean];
}

#pragma mark - 懒加载

- (UIView *)loadingControlPanel
{
    if (!_loadingControlPanel) {
        UIView *loadingControlPanel = [[UIView alloc] init];
        _loadingControlPanel = loadingControlPanel;
        loadingControlPanel.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1.0];
        loadingControlPanel.clipsToBounds = YES;
        [self addSubview:loadingControlPanel];
        [loadingControlPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.adjustsImageWhenHighlighted = NO;
        [backBtn setImage:[UIImage imageNamed:@"icnav_back_dark"] forState:UIControlStateNormal];
        backBtn.rac_command = self.handleBackCommand;
        [loadingControlPanel addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loadingControlPanel.mas_top).offset(22.0);
            make.left.equalTo(loadingControlPanel.mas_left).offset(14.0);
        }];
        UIButton *screenOrientationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        screenOrientationBtn.adjustsImageWhenHighlighted = NO;
        [screenOrientationBtn setImage:[UIImage imageNamed:@"player_fullScreen_iphone"] forState:UIControlStateNormal];
        screenOrientationBtn.rac_command = self.handleFullScreenCommand;
        [loadingControlPanel addSubview:screenOrientationBtn];
        [screenOrientationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(loadingControlPanel.mas_right).offset(-14.0);
            make.bottom.equalTo(loadingControlPanel.mas_bottom).offset(-14.0);
        }];
        
        NSMutableArray *animateImages = [NSMutableArray array];
        for (int i = 1; i <= 5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"player_loadin_%d", i]];
            [animateImages addObject:image];
        }
        UIImageView *loadingImageView = [[UIImageView alloc] init];
        loadingImageView.animationImages = animateImages;
        loadingImageView.animationDuration = animateImages.count * 1 / 30;
        loadingImageView.animationRepeatCount = 0;
        [loadingControlPanel addSubview:loadingImageView];
        CGFloat loadingImageViewWidth = widthEx(72.0);
        [loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(loadingControlPanel.mas_centerX).offset(8.0);
            make.centerY.equalTo(loadingControlPanel.mas_centerY);
            make.width.height.mas_equalTo(loadingImageViewWidth);
        }];
        [loadingImageView startAnimating];
        
        UIButton *stateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        stateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [stateBtn setTitleColor:kTextColor forState:UIControlStateNormal];
        [stateBtn setTitle:@"复制信息" forState:UIControlStateNormal];
        [loadingControlPanel addSubview:stateBtn];
        [stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(loadingControlPanel.mas_right).offset(-14.0);
            make.centerY.equalTo(backBtn.mas_centerY);
        }];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        _detailLabel = detailLabel;
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.numberOfLines = 0;
        [loadingControlPanel addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(loadingControlPanel.mas_left).offset(10.0);
            make.right.equalTo(loadingImageView.mas_left).offset(-4.0);
            make.bottom.equalTo(loadingControlPanel.mas_bottom).offset(-4.0);
        }];
    }
    return _loadingControlPanel;
}

- (DdPortraitMediaControl *)portraitMediaControl
{
    if (!_portraitMediaControl) {
        DdPortraitMediaControl *portraitMediaControl = [[DdPortraitMediaControl alloc] init];
        _portraitMediaControl = portraitMediaControl;
        [self addSubview:portraitMediaControl];
        [portraitMediaControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _portraitMediaControl;
}

- (DdLandscapeMediaControl *)landscapeMediaControl
{
    if (!_landscapeMediaControl) {
        DdLandscapeMediaControl *landscapeMediaControl = [[DdLandscapeMediaControl alloc] init];
        _landscapeMediaControl = landscapeMediaControl;
        [self addSubview:landscapeMediaControl];
        [landscapeMediaControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _landscapeMediaControl;
}

#pragma mark - Getter
#pragma mark 获取状态栏隐藏状态
- (BOOL)statusBarHidden
{
    if (_interfaceOrientationMask == UIInterfaceOrientationMaskPortrait) {
        return _portraitMediaControl.statusBarHidden;
    }else if (_interfaceOrientationMask == UIInterfaceOrientationMaskLandscape) {
        return _landscapeMediaControl.statusBarHidden;
    }
    return NO;
}

#pragma mark - Setter
#pragma mark 加载描述
- (void)setLoadingDetail:(NSString *)loadingDetail
{
    if (_loadingDetail) {
        _loadingDetail = [NSString stringWithFormat:@"%@\n%@", _loadingDetail, loadingDetail];
        self.detailLabel.text = _loadingDetail;
        [UIView animateWithDuration:0.25 animations:^{
            [self.detailLabel layoutIfNeeded];
        }];
    }else {
        _loadingDetail = loadingDetail;
        self.detailLabel.text = _loadingDetail;
    }
}

#pragma mark 屏幕旋转
- (void)setInterfaceOrientationMask:(UIInterfaceOrientationMask)interfaceOrientationMask
{
    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationUnknown;
    if (interfaceOrientationMask == UIInterfaceOrientationMaskLandscapeRight || interfaceOrientationMask == UIInterfaceOrientationMaskLandscapeLeft) {
        //设置横屏
        interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        _interfaceOrientationMask = UIInterfaceOrientationMaskLandscape;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
    }else if (interfaceOrientationMask == UIInterfaceOrientationMaskPortrait) {
        // 设置竖屏
        interfaceOrientation = UIInterfaceOrientationPortrait;
        _interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.superview);
            make.height.equalTo(self.mas_width).multipliedBy(0.5625);
        }];
    }
    
    [self refreshMediaControl];
    
    //强制旋转
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:device];
        int val = interfaceOrientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - Utility
#pragma mark 刷新媒体控制器
- (void)refreshMediaControl
{
    if (self.delegatePlayer.isPreparedToPlay) {
        [_portraitMediaControl clean];
        [_landscapeMediaControl clean];
        [self removeAllSubviews];
        _portraitMediaControl = nil;
        _landscapeMediaControl = nil;
        
        if (_interfaceOrientationMask == UIInterfaceOrientationMaskPortrait) {
            
            self.portraitMediaControl.title = self.title;
            self.portraitMediaControl.handleBackCommand = self.handleBackCommand;
            self.portraitMediaControl.handleFullScreenCommand = self.handleFullScreenCommand;
            self.portraitMediaControl.handleMoreCommand = self.handleMoreCommand;
            self.portraitMediaControl.handleStatusBarHiddenCommand = self.handleStatusBarHiddenCommand;
            self.portraitMediaControl.delegatePlayer = self.delegatePlayer;
            
            [self.portraitMediaControl refreshPortraitMediaControl];
            
        }else if (_interfaceOrientationMask == UIInterfaceOrientationMaskLandscape) {
            
            self.landscapeMediaControl.title = self.title;
            self.landscapeMediaControl.handleBackCommand = self.handleBackCommand;
            self.landscapeMediaControl.handleFullScreenCommand = self.handleFullScreenCommand;
            self.landscapeMediaControl.handleStatusBarHiddenCommand = self.handleStatusBarHiddenCommand;
            self.landscapeMediaControl.delegatePlayer = self.delegatePlayer;
            self.landscapeMediaControl.danmakuVM = self.danmakuVM;
            
            [self.landscapeMediaControl refreshLandscapeMediaControl];
        }
    }else {
        self.loadingControlPanel.hidden = NO;
    }
}

#pragma mark 配置通知中心
- (void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:nil];
}

#pragma mark 移除通知中心
- (void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
}

#pragma mark 准备播放
- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification
{
    DDLogInfo(@"mediaIsPreparedToPlayDidChange\n");
    [self refreshMediaControl];
    [self.delegatePlayer play];
}

@end
