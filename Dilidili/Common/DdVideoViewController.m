//
//  DdVideoViewController.m
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoViewController.h"
#import "DdVideoInfoViewController.h"
#import "DdVideoReplyViewController.h"
#import "DdDanmakuViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "BSMultiViewControl.h"
#import "DdMediaControl.h"
#import "DdProgressHUD.h"
#import "BSActionSheet.h"
#import "YPPlayerFPSLabel.h"
#import "DdImageManager.h"
#import "DdFormatter.h"

@interface DdVideoViewController () <UITextFieldDelegate, BSMultiViewControlDataSource, BSMultiViewControlDelegate>
{
    NSString *_aid;  //视频标识
    NSString *_cid;  //弹幕标识
}

/** 视频信息视图控制器 */
@property (nonatomic, strong) DdVideoInfoViewController *ivc;
/** 视频评论视图控制器 */
@property (nonatomic, strong) DdVideoReplyViewController *rvc;
/** 弹幕视图控制器 */
@property (nonatomic, strong) DdDanmakuViewController *dvc;
/** 预览图片视图 */
@property (nonatomic, weak) UIImageView *previewImageView;
/** 视频播放器 */
@property (atomic, strong) IJKFFMoviePlayerController *player;
/** 媒体控制器 */
@property (nonatomic, weak) DdMediaControl *mediaControl;
/** 弹幕输入视图 */
@property (nonatomic, weak) UIView *danmakuEntryView;
/** 遮罩视图 */
@property (nonatomic, weak) UIControl *overlayView;
/** 内容视图 */
@property (nonatomic, weak) BSMultiViewControl *contentView;
/** 媒体URL */
@property (nonatomic, copy) NSURL *contentURL;

@end

@implementation DdVideoViewController

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
    _aid = [self.originUrl.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    [self createUI];
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

- (void)createUI
{
    UIImageView *previewImageView = [[UIImageView alloc] init];
    _previewImageView = previewImageView;
    previewImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:previewImageView];
    [previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(previewImageView.mas_width).multipliedBy(0.5625);
    }];
    
    NSURL *url;
    if (self.params[@"cover"]) {
        url = [NSURL URLWithString:self.params[@"cover"]];
    }
    [previewImageView setImageWithURL:url placeholder:nil options:YYWebImageOptionIgnoreDiskCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.previewImageView.image = [[image imageByResizeToSize:CGSizeMake(kScreenWidth * kScreenScale, kScreenWidth * 0.5625 * kScreenScale) contentMode:UIViewContentModeScaleAspectFill] imageByBlurRadius:15 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
        [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0];
    }];
}

- (DdMediaControl *)mediaControl
{
    if (!_mediaControl) {
        DdMediaControl *mediaControl = [[DdMediaControl alloc] init];
        _mediaControl = mediaControl;
        [self.view addSubview:mediaControl];
        [mediaControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(mediaControl.mas_width).multipliedBy(0.5625);
        }];
        
        mediaControl.title = self.params[@"title"];
        
        @weakify(self);
#pragma mark Action - 返回
        mediaControl.handleBackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                if (self.mediaControl.interfaceOrientationMask == UIInterfaceOrientationMaskLandscape) {
                    self.mediaControl.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
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
                    
                }else if (self.mediaControl.interfaceOrientationMask == UIInterfaceOrientationMaskLandscape) {
                    
                    self.mediaControl.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
                    
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
                BSActionSheet *actionSheet = [[BSActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"举报"] onButtonTouchUpInside:^(BSActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
 
                }];
                [actionSheet show];
                
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        
    }
    return _mediaControl;
}

- (UIView *)danmakuEntryView
{
    if (!_danmakuEntryView) {
        UIView *danmakuEntryView = [[UIView alloc] init];
        _danmakuEntryView = danmakuEntryView;
        danmakuEntryView.backgroundColor = [UIColor colorWithWhite:33 / 255.0 alpha:1.0];
        danmakuEntryView.clipsToBounds = YES;
        [self.view addSubview:danmakuEntryView];
        [danmakuEntryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.mediaControl.mas_bottom);
            make.height.mas_equalTo(40.0);
        }];
        
        YYAnimatedImageView *faceImageView = [[YYAnimatedImageView alloc] init];
        [danmakuEntryView addSubview:faceImageView];
        CGFloat faceWidth = 26.0;
        [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(danmakuEntryView.mas_left).offset(10.0);
            make.centerY.equalTo(danmakuEntryView.mas_centerY);
            make.width.height.mas_equalTo(faceWidth);
        }];
        [faceImageView setImageWithURL:nil placeholder:[DdImageManager face_placeholderImage] options:YYWebImageOptionIgnoreDiskCache progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            
            UIImage *transformImage = [image imageByResizeToSize:CGSizeMake(faceWidth * kScreenScale, faceWidth * kScreenScale)];
            transformImage = [transformImage imageByRoundCornerRadius:transformImage.size.width / 2 borderWidth:2.0 borderColor:[UIColor whiteColor]];
            return transformImage;
            
        } completion:NULL];
        
        UITextField *danmakuTextField = [[UITextField alloc] init];
        danmakuTextField.delegate = self;
        danmakuTextField.borderStyle = UITextBorderStyleNone;
        danmakuTextField.backgroundColor = [UIColor darkGrayColor];
        danmakuTextField.tintColor = kThemeColor;
        danmakuTextField.textColor = [UIColor lightGrayColor];
        danmakuTextField.font = [UIFont systemFontOfSize:14];
        danmakuTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        danmakuTextField.returnKeyType = UIReturnKeySend;
        CGFloat textFieldHeight = 24.0;
        UIFont *placeholderFont = [UIFont systemFontOfSize:12];
        NSMutableParagraphStyle *style = [danmakuTextField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        style.minimumLineHeight = danmakuTextField.font.lineHeight - (danmakuTextField.font.lineHeight - placeholderFont.lineHeight) / 2;
        [danmakuTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"发个弹幕呗" attributes:@{NSFontAttributeName:placeholderFont, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName:style}]];
        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFieldHeight / 2, textFieldHeight)];
        danmakuTextField.leftViewMode = UITextFieldViewModeAlways;
        danmakuTextField.leftView = emptyView;
        danmakuTextField.rightViewMode = UITextFieldViewModeAlways;
        danmakuTextField.rightView = emptyView;
        danmakuTextField.layer.cornerRadius = textFieldHeight / 2;
        danmakuTextField.layer.masksToBounds = YES;
        [danmakuEntryView addSubview:danmakuTextField];
        [danmakuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(faceImageView.mas_right).offset(10.0);
            make.right.equalTo(danmakuEntryView.mas_right).offset(-12.0);
            make.centerY.equalTo(faceImageView.mas_centerY);
            make.height.mas_equalTo(textFieldHeight);
        }];
    }
    return _danmakuEntryView;
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
        [self.view addSubview:overlayView];
        [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
    }
    return _overlayView;
}

- (BSMultiViewControl *)contentView
{
    if (!_contentView) {
        BSMultiViewControl *contentView = [[BSMultiViewControl alloc] initWithFrame:CGRectZero andStyle:BSMultiViewControlFixedPageSize owner:self];
        _contentView = contentView;
        contentView.dataSource = self;
        contentView.delegate = self;
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.fixedPageSize = 2;
        contentView.listBarWidth = self.view.width - 2 * 50.0;
        contentView.listBarHeight = 30.0;
        contentView.selectedButtonBottomLineColor = kThemeColor;
        contentView.bounces = NO;
        contentView.selectedIndex = 1;
        [self.view addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.danmakuEntryView.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom).priorityLow();
        }];
    }
    return _contentView;
}

#pragma mark - Setter

- (void)setContentURL:(NSURL *)contentURL
{
    _contentURL = contentURL;
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURL:contentURL withOptions:options];
    _player = player;
    player.scalingMode = IJKMPMovieScalingModeAspectFit;
    player.shouldAutoplay = NO;
    [self.view insertSubview:player.view belowSubview:self.mediaControl];
    [player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.mediaControl);
    }];
    
    UIView *overlayView = [[UIView alloc] init];
    overlayView.userInteractionEnabled = NO;
    overlayView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:overlayView belowSubview:player.view];
    [overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(player.view);
    }];
}

#pragma mark - MultiViewControl

- (NSUInteger)numberOfItemsInMultiViewControl:(BSMultiViewControl *)multiViewControl
{
    return 2;
}

- (UIButton *)multiViewControl:(BSMultiViewControl *)multiViewControl buttonAtIndex:(NSUInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:kThemeColor forState:UIControlStateSelected];
    if (index == 0) {
        [button setTitle:@"简介" forState:UIControlStateNormal];
    }else if (index == 1) {
        [button setTitle:@"评论" forState:UIControlStateNormal];
    }
    return button;
}

- (UIViewController *)multiViewControl:(BSMultiViewControl *)multiViewControl viewControllerAtIndex:(NSUInteger)index
{
    UIViewController *vc = nil;
    if (index == 0) {
        vc = self.ivc;
    }else if (index == 1) {
        vc = self.rvc;
    }
    return vc;
}

- (void)multiViewControl:(BSMultiViewControl *)multiViewControl didSelectViewController:(UIViewController *)vc atIndex:(NSUInteger)index
{
    
}

#pragma mark - Utility
#pragma mark 请求数据
- (void)requestData
{
    [_previewImageView removeFromSuperview];
    [self.mediaControl refreshMediaControl];
    self.mediaControl.loadingDetail = @"正在获取视频信息...";
    
    self.ivc = [[DdVideoInfoViewController alloc] init];
    self.ivc.aid = _aid;
    self.ivc.from = self.params[@"from"];
    RACSignal *infoSignal = [self.ivc requestData];
    [infoSignal subscribeNext:^(DdVideoModel *model) {
        
        self.mediaControl.loadingDetail = @"成功...\n正在获取视频地址...";
        [self requestVideoURL];
        
    } error:^(NSError *error) {
        
        self.mediaControl.loadingDetail = @"失败...\n正在获取视频地址...";
        [self requestVideoURL];
        
    }];
    
    self.rvc = [[DdVideoReplyViewController alloc] init];
    self.rvc.oid = _aid;
    self.rvc.pageNum = 1;
    RACSignal *repliesSignal = [self.rvc requestData];
    [repliesSignal subscribeNext:^(RACTuple *tuple) {
        [self.contentView performUpdatesWithAnimateDuration:0 updates:^(BSMultiViewControl *multiViewControl) {
            NSDictionary *page = tuple.third;
            UIButton *button = multiViewControl.buttons[1];
            [button setTitle:[NSString stringWithFormat:@"评论（%@）", [DdFormatter stringForCount:[page[@"acount"] unsignedIntegerValue]]] forState:UIControlStateNormal];
        } completion:NULL];
    }];
    
    self.danmakuEntryView.hidden = NO;
    [self.contentView reloadData];
}

#pragma mark 请求视频播放链接
- (void)requestVideoURL
{
    [[[DdVideoViewModel requestVideoURLByAid:_aid] execute:nil] subscribeNext:^(NSDictionary *responseDict) {
        _cid = responseDict[@"cid"];
        NSDictionary *urlDict = [responseDict[@"durl"] firstObject];
        self.contentURL = [NSURL URLWithString:urlDict[@"url"]];
        self.mediaControl.delegatePlayer = self.player;
        self.mediaControl.loadingDetail = @"正在初始化设置...\n正在载入弹幕...";
        [self requestVideoDanmaku];
    } error:^(NSError *error) {
        self.mediaControl.loadingDetail = @"失败...";
    }];
}

#pragma mark 请求视频弹幕
- (void)requestVideoDanmaku
{
    self.dvc = [[DdDanmakuViewController alloc] init];
    self.dvc.cid = _cid;
    [self.view insertSubview:self.dvc.view belowSubview:self.mediaControl];
    [self.dvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.mediaControl);
    }];
    [self addChildViewController:self.dvc];
    RACSignal *danmakuSignal = [self.dvc requestData];
    [danmakuSignal subscribeNext:^(id  _Nullable x) {
        self.mediaControl.loadingDetail = @"成功...\n载入视频中...";
        self.mediaControl.dvc = self.dvc;
        self.dvc.delegatePlayer = self.player;
        [self.player prepareToPlay];
#ifdef DEBUG
        [YPPlayerFPSLabel showWithPlayer:self.player];
#endif
    } error:^(NSError * _Nullable error) {
        self.mediaControl.loadingDetail = @"失败...\n载入视频中...";
        [self.player prepareToPlay];
#ifdef DEBUG
        [YPPlayerFPSLabel showWithPlayer:self.player];
#endif
    }];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.dvc.renderer receive:[[DdDanmakuUserDefaults sharedInstance] preferredDanmakuDescriptorWithText:textField.text]];
    [textField resignFirstResponder];
    return YES;
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
