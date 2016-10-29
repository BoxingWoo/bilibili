//
//  LiveVideoViewController.m
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveVideoViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LiveInteractionViewController.h"
#import "LiveMomijiViewController.h"
#import "LiveSevenRankingViewController.h"
#import "LiveFansRankingViewController.h"
#import "BSMultiViewControl.h"
#import "LiveMediaControl.h"
#import "LiveRecommendView.h"
#import "DdImageManager.h"
#import "DdProgressHUD.h"
#import "BSActionSheet.h"
#import "YPPlayerFPSLabel.h"
#import "LiveVideoViewModel.h"

@interface LiveVideoViewController () <UITextFieldDelegate, BSMultiViewControlDataSource, BSMultiViewControlDelegate, YYTextKeyboardObserver>

/** 播放准备视图 */
@property (nonatomic, weak) UIView *prepareView;
/** 视频播放器 */
@property (atomic, strong) IJKFFMoviePlayerController *player;
/** 直播媒体控制器 */
@property (nonatomic, weak) LiveMediaControl *mediaControl;
/** 用户视图 */
@property (nonatomic, weak) UIView *userView;
/** 弹幕输入视图 */
@property (nonatomic, weak) UIView *danmakuEntryView;
/** 遮罩视图 */
@property (nonatomic, weak) UIControl *overlayView;
/** 内容视图 */
@property (nonatomic, weak) BSMultiViewControl *contentView;

/** 内容标题数组 */
@property (nonatomic, copy) NSArray *contentTitles;
/** 直播视频视图模型 */
@property (nonatomic, strong) LiveVideoViewModel *viewModel;

@end

@implementation LiveVideoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    [IJKFFMoviePlayerController setLogReport:NO];
#else
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_ERROR];
    [IJKFFMoviePlayerController setLogReport:NO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBgColor;
    
    [self configureData];
    
    [self createUI];
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.player prepareToPlay];
    
#ifdef DEBUG
    [YPPlayerFPSLabel showWithPlayer:self.player];
#endif
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
    
#ifdef DEBUG
    [YPPlayerFPSLabel dismiss];
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DDLogWarn(@"%@ dealloc！", [self.class description]);
}

#pragma mark - Initialization

- (void)configureData
{
    if ([self.originUrl.absoluteString isNotBlank]) {
        _room_id = [[self.originUrl.path stringByReplacingOccurrencesOfString:@"/" withString:@""] integerValue];
    }
    
    _contentTitles = @[@"互动", @"红叶祭", @"七日榜", @"粉丝榜"];
}

- (void)createUI
{
    UIView *prepareView = [[UIView alloc] init];
    _prepareView = prepareView;
    prepareView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:prepareView];
    [prepareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(prepareView.mas_width).multipliedBy(0.5625);
    }];
    @weakify(self);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.adjustsImageWhenHighlighted = NO;
    [backBtn setImage:[UIImage imageNamed:@"common_back_v2"] forState:UIControlStateNormal];
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [prepareView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prepareView.mas_top).offset(24.0);
        make.left.equalTo(prepareView.mas_left).offset(20.0);
    }];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.adjustsImageWhenHighlighted = NO;
    [moreBtn setImage:[UIImage imageNamed:@"icmpv_more_light"] forState:UIControlStateNormal];
    [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    [prepareView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(prepareView.mas_right).offset(-16.0);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    UIView *userView = [[UIView alloc] init];
    _userView = userView;
    userView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userView];
    [userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(prepareView.mas_bottom);
        make.height.mas_equalTo(75.0);
    }];
    UIView *line = [[UIView alloc] init];
    line.userInteractionEnabled = NO;
    line.backgroundColor = kBorderColor;
    [userView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(userView);
        make.height.mas_equalTo(0.5);
    }];
    
    BSMultiViewControl *contentView = [[BSMultiViewControl alloc] initWithFrame:CGRectZero andStyle:BSMultiViewControlFixedPageSize owner:self];
    _contentView = contentView;
    contentView.dataSource = self;
    contentView.delegate = self;
    contentView.listBarBackgroundColor = [UIColor whiteColor];
    contentView.listBarHeight = 35.0;
    contentView.fixedPageSize = 4;
    contentView.selectedButtonBottomLineColor = kThemeColor;
    contentView.bounces = NO;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(userView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).priorityLow();
    }];
    [contentView reloadData];
    
    UIView *danmakuEntryView = [[UIView alloc] init];
    _danmakuEntryView = danmakuEntryView;
    danmakuEntryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:danmakuEntryView];
    [danmakuEntryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49.0);
    }];
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giftBtn.adjustsImageWhenHighlighted = NO;
    [giftBtn setImage:[UIImage imageNamed:@"live_gift_ico~iphone"] forState:UIControlStateNormal];
    [giftBtn addTarget:self action:@selector(handleGivingGift:) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.tag = -1;
    [danmakuEntryView addSubview:giftBtn];
    [giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(danmakuEntryView.mas_left).offset(10.0);
        make.centerY.equalTo(danmakuEntryView.mas_centerY);
    }];
    UITextField *danmakuTextField = [[UITextField alloc] init];
    danmakuTextField.delegate = self;
    danmakuTextField.borderStyle = UITextBorderStyleNone;
    danmakuTextField.backgroundColor = [UIColor colorWithWhite:239 / 255.0 alpha:1.0];
    danmakuTextField.tintColor = kThemeColor;
    danmakuTextField.textColor = kTextColor;
    danmakuTextField.font = [UIFont systemFontOfSize:14];
    danmakuTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    danmakuTextField.returnKeyType = UIReturnKeySend;
    CGFloat textFieldHeight = 32.0;
    UIFont *placeholderFont = [UIFont systemFontOfSize:12];
    NSMutableParagraphStyle *style = [danmakuTextField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.minimumLineHeight = danmakuTextField.font.lineHeight - (danmakuTextField.font.lineHeight - placeholderFont.lineHeight) / 2;
    [danmakuTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"输入想发送的弹幕" attributes:@{NSFontAttributeName:placeholderFont, NSForegroundColorAttributeName:[UIColor lightGrayColor], NSParagraphStyleAttributeName:style}]];
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldHeight / 2, textFieldHeight)];
    danmakuTextField.leftViewMode = UITextFieldViewModeAlways;
    danmakuTextField.leftView = emptyView;
    danmakuTextField.rightViewMode = UITextFieldViewModeAlways;
    danmakuTextField.rightView = emptyView;
    danmakuTextField.layer.cornerRadius = textFieldHeight / 2;
    danmakuTextField.layer.masksToBounds = YES;
    [danmakuEntryView addSubview:danmakuTextField];
    [danmakuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(giftBtn.mas_right).offset(10.0);
        make.right.equalTo(danmakuEntryView.mas_right).offset(-10.0);
        make.centerY.equalTo(giftBtn.mas_centerY);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [danmakuTextField setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [danmakuTextField setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
}

- (LiveMediaControl *)mediaControl
{
    if (!_mediaControl) {
        LiveMediaControl *mediaControl = [[LiveMediaControl alloc] init];
        _mediaControl = mediaControl;
        [self.view addSubview:mediaControl];
        [mediaControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(mediaControl.mas_width).multipliedBy(0.5625);
        }];
        
        mediaControl.model = self.viewModel.model;
        @weakify(self);
#pragma mark Action - 返回
        mediaControl.handleBackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                if (self.mediaControl.interfaceOrientationMask == UIInterfaceOrientationMaskLandscape) {
                    self.mediaControl.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
                    self.danmakuEntryView.hidden = NO;
                }else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        
#pragma mark Action - 屏幕切换
        mediaControl.handleFullScreenCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [self.view endEditing:YES];
                if (self.mediaControl.interfaceOrientationMask == UIInterfaceOrientationMaskPortrait) {
                    
                    self.mediaControl.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
                    self.danmakuEntryView.hidden = YES;
                    
                }else if (self.mediaControl.interfaceOrientationMask == UIInterfaceOrientationMaskLandscape) {
                    
                    self.mediaControl.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
                    self.danmakuEntryView.hidden = NO;
                    
                }
                
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        
#pragma mark Action - 显示/隐藏状态栏
        mediaControl.handleStatusBarHiddenCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [subscriber sendNext:self];
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];

#pragma mark Action - 更多
        mediaControl.handleMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                BSActionSheet *actionSheet = [[BSActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"分享", @"举报"] onButtonTouchUpInside:^(BSActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {

                }];
                actionSheet.tintColor = kThemeColor;
                [actionSheet show];
                
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        
        NSURL *contentURL = [NSURL URLWithString:self.playurl];
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURL:contentURL withOptions:options];
        _player = player;
        player.scalingMode = IJKMPMovieScalingModeAspectFit;
        player.shouldAutoplay = NO;
        [self.view insertSubview:player.view belowSubview:mediaControl];
        [player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(mediaControl);
        }];
    }
    return _mediaControl;
}

- (UIControl *)overlayView
{
    if (!_overlayView) {
        UIControl *overlayView = [[UIControl alloc] init];
        _overlayView = overlayView;
        overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [[overlayView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            [self.view endEditing:YES];
        }];
        [self.view insertSubview:overlayView belowSubview:self.danmakuEntryView];
        [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.userView.mas_top);
        }];
    }
    return _overlayView;
}

#pragma mark - MultiViewControl

- (NSUInteger)numberOfItemsInMultiViewControl:(BSMultiViewControl *)multiViewControl
{
    return self.contentTitles.count;
}

- (UIButton *)multiViewControl:(BSMultiViewControl *)multiViewControl buttonAtIndex:(NSUInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:self.contentTitles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:kThemeColor forState:UIControlStateSelected];
    return button;
}

- (UIViewController *)multiViewControl:(BSMultiViewControl *)multiViewControl viewControllerAtIndex:(NSUInteger)index
{
    UIViewController *vc = nil;
    if (index == 0) {
        LiveInteractionViewController *ivc = [[LiveInteractionViewController alloc] init];
        vc = ivc;
    }else if (index == 1) {
        LiveMomijiViewController *mvc = [[LiveMomijiViewController alloc] init];
        vc = mvc;
    }else if (index == 2) {
        LiveSevenRankingViewController *svc = [[LiveSevenRankingViewController alloc] init];
        vc = svc;
    }else if (index == 3) {
        LiveFansRankingViewController *fvc = [[LiveFansRankingViewController alloc] init];
        vc = fvc;
    }
    return vc;
}

- (void)multiViewControl:(BSMultiViewControl *)multiViewControl didSelectViewController:(UIViewController *)vc atIndex:(NSUInteger)index
{
    
}

#pragma mark - HandleAction
#pragma mark 送礼物
- (void)handleGivingGift:(UIButton *)button
{
    button.tag *= -1;
}

#pragma mark 添加关注
- (void)handleAddingAttention:(UIButton *)button
{
    
}

#pragma mark 跳转推荐直播
- (void)handleShowingRecommend:(UIControl *)sender
{
//    LiveModel *model = self.viewModel.model.recommend[sender.tag];
//    LiveVideoViewController *vvc = [[LiveVideoViewController alloc] init];
//    vvc.room_id = model.room_id;
//    vvc.playurl = model.playurl;
//    [self.navigationController pushViewController:vvc animated:YES];
}

#pragma mark Utility
#pragma mark 请求数据
- (void)requestData
{
    [[[LiveVideoViewModel requestLiveInfoByRoomID:self.room_id] execute:nil] subscribeNext:^(LiveInfoModel *model) {
        
        self.viewModel = [[LiveVideoViewModel alloc] initWithModel:model];
        [self refreshUI];
        
    } error:^(NSError * _Nullable error) {
        [DdProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark 刷新界面
- (void)refreshUI
{
    if ([self.viewModel.model.status isEqualToString:@"LIVE"]) {  //直播中...
        [self.mediaControl refreshMediaControl];
        self.mediaControl.loadingDetail = @"正在初始化设置...\n正在载入弹幕...";
        self.mediaControl.loadingDetail = @"载入视频中...";
        if (self.player) {
            self.mediaControl.delegatePlayer = self.player;
            [self.player prepareToPlay];
        }else {
            self.mediaControl.loadingDetail = @"失败...";
        }
#ifdef DEBUG
        [YPPlayerFPSLabel showWithPlayer:self.player];
#endif
    }else {  //准备中...
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = kThemeColor;
        titleLabel.text = self.viewModel.model.prepare;
        [self.prepareView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.prepareView.mas_top).offset(29.0);
            make.centerX.equalTo(self.prepareView.mas_centerX);
        }];
        
        CGFloat width = widthEx(96.0);
        CGFloat height = heightEx(60.0) + 34.0;
        for (NSInteger i = 0; i < self.viewModel.model.recommend.count; i++) {
            LiveRecommendView *recommendView = [[LiveRecommendView alloc] init];
            [self.prepareView addSubview:recommendView];
            if (i == 0) {
                [recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.prepareView.mas_centerX).offset(-9.0);
                    make.bottom.equalTo(self.prepareView.mas_bottom).offset(-16.0);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);
                }];
            }else if (i == 1) {
                [recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.prepareView.mas_centerX).offset(9.0);
                    make.bottom.equalTo(self.prepareView.mas_bottom).offset(-16.0);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);
                }];
            }
            
            LiveModel *model = self.viewModel.model.recommend[i];
            [recommendView.coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:[DdImageManager live_placeholderImageBySize:CGSizeMakeEx(96.0, 60.0)]];
            [recommendView.faceImageView setImageWithURL:[NSURL URLWithString:model.owner.face] placeholder:[DdImageManager face_placeholderImage] options:YYWebImageOptionIgnoreDiskCache progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                UIImage *transformImage = [image imageByResizeToSize:CGSizeMake(recommendView.faceImageView.width * kScreenScale, recommendView.faceImageView.height * kScreenScale)];
                transformImage = [transformImage imageByRoundCornerRadius:transformImage.size.width / 2 borderWidth:2.0 borderColor:kBorderColor];
                return transformImage;
            } completion:NULL];
            recommendView.nameLabel.text = model.owner.name;
            recommendView.titleLabel.text = model.title;
            recommendView.onlineLabel.text = [DdFormatter stringForCount:model.online];
            recommendView.tag = i;
            [recommendView addTarget:self action:@selector(handleShowingRecommend:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIImageView *userHeadImageView = [[UIImageView alloc] init];
    [self.userView addSubview:userHeadImageView];
    [userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userView.mas_left).offset(8.0);
        make.centerY.equalTo(self.userView.mas_centerY);
        make.width.and.height.mas_equalTo(60.0);
    }];
    [userHeadImageView setImageWithURL:[NSURL URLWithString:self.viewModel.model.face] placeholder:[DdImageManager face_placeholderImage] options:YYWebImageOptionIgnoreDiskCache progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        UIImage *transformImage = [image imageByResizeToSize:CGSizeMake(60 * kScreenScale, 60 * kScreenScale)];
        transformImage = [transformImage imageByRoundCornerRadius:transformImage.size.width / 2];
        return transformImage;
    } completion:NULL];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = kTextColor;
    titleLabel.text = self.viewModel.model.title;
    [self.userView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userHeadImageView.mas_right).offset(6.0);
        make.top.equalTo(self.userView.mas_top).offset(10.0);
    }];
    
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.backgroundColor = [UIColor colorWithRGBA:self.viewModel.model.master_level_color];
    levelLabel.font = [UIFont systemFontOfSize:11];
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.text = [NSString stringWithFormat:@"UP%lu", self.viewModel.model.master_level];
    [self.userView addSubview:levelLabel];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_left);
        make.top.equalTo(titleLabel.mas_bottom).offset(8.0);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:10];
    nameLabel.textColor = kThemeColor;
    nameLabel.text = self.viewModel.model.uname;
    [self.userView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelLabel.mas_right).offset(10.0);
        make.centerY.equalTo(levelLabel.mas_centerY);
    }];
    
    UIButton *onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    onlineBtn.userInteractionEnabled = NO;
    onlineBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [onlineBtn setImage:[UIImage imageNamed:@"live_eye_ico"] forState:UIControlStateNormal];
    [onlineBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [onlineBtn setTitle:[DdFormatter stringForCount:self.viewModel.model.online] forState:UIControlStateNormal];
    [self.userView addSubview:onlineBtn];
    [onlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelLabel.mas_left);
        make.top.equalTo(levelLabel.mas_bottom).offset(10.0);
    }];
    
    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [attentionBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    [attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(handleAddingAttention:) forControlEvents:UIControlEventTouchUpInside];
    attentionBtn.layer.cornerRadius = 4.0;
    attentionBtn.layer.borderColor = kThemeColor.CGColor;
    attentionBtn.layer.borderWidth = 1.0;
    [self.userView addSubview:attentionBtn];
    [attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userView.mas_right).offset(-16.0);
        make.bottom.equalTo(self.userView.mas_bottom).offset(-12.0);
        make.width.mas_equalTo(56.0);
        make.height.mas_equalTo(28.0);
    }];
    
    UILabel *attentionCountLabel = [[UILabel alloc] init];
    attentionCountLabel.font = [UIFont systemFontOfSize:11];
    attentionCountLabel.textColor = [UIColor lightGrayColor];
    attentionCountLabel.textAlignment = NSTextAlignmentCenter;
    attentionCountLabel.text = [DdFormatter stringForCount:self.viewModel.model.attention];
    attentionCountLabel.layer.cornerRadius = 4.0;
    attentionCountLabel.layer.masksToBounds = YES;
    attentionCountLabel.layer.borderColor = kBorderColor.CGColor;
    attentionCountLabel.layer.borderWidth = 1.0;
    [self.userView addSubview:attentionCountLabel];
    [attentionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(attentionBtn.mas_left).offset(-8.0);
        make.centerY.equalTo(attentionBtn.mas_centerY);
        make.width.mas_equalTo(36.0);
        make.height.mas_equalTo(24.0);
    }];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    self.overlayView.hidden = NO;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.text = nil;
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - YYTextKeyboardObserver

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    CGFloat offset = toFrame.origin.y - self.view.height;
    [self.danmakuEntryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(offset);
    }];
    if (transition.animationDuration != 0) {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.danmakuEntryView layoutIfNeeded];
        } completion:NULL];
    }
}

#pragma mark - Others

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (_mediaControl) {
        return self.mediaControl.interfaceOrientationMask;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    if (_mediaControl) {
        return self.mediaControl.statusBarHidden;
    }
    
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
