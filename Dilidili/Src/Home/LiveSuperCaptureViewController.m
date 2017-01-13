//
//  LiveSuperCaptureViewController.m
//  Dilidili
//
//  Created by iMac on 2016/10/31.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveSuperCaptureViewController.h"
#import "LiveCaptureViewModel.h"
#import <LFLiveKit/LFLiveKit.h>

@interface LiveSuperCaptureViewController ()<LFLiveSessionDelegate>
{
    CGFloat _panGestureOffsetX;  //拖动手势横向位移
}

/** 直播推流视图模型 */
@property (nonatomic, strong) LiveCaptureViewModel *viewModel;
/** 内容视图 */
@property (nonatomic, weak) UIView *contentView;
/** 直播会话 */
@property (nonatomic, strong) LFLiveSession *session;
/** 直播视音频流信息 */
@property (nonatomic, strong) LFLiveStreamInfo *streamInfo;
/** 预览视图  */
@property (nonatomic, weak) UIView *captureVideoPreview;

@end

@implementation LiveSuperCaptureViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
    
    [self createUI];
    
    [self setupCaputure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.session startLive:self.streamInfo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.session stopLive];
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView = contentView;
    [self.view addSubview:contentView];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *faceImageView = [[UIImageView alloc] init];
    UIImage *faceImage = [UIImage imageNamed:@"avatar3.jpg"];
    faceImage = [faceImage imageByRoundCornerRadius:faceImage.size.width / 2];
    faceImageView.image = faceImage;
    [contentView addSubview:faceImageView];
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(8.0);
        make.top.equalTo(contentView.mas_top).offset(26.0);
        make.width.height.mas_equalTo(40.0);
    }];
    
    @weakify(self);
    UIButton *placeholderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    placeholderBtn.userInteractionEnabled = NO;
    [placeholderBtn setImage:[UIImage imageNamed:@"mg_room_btn_guan_h"] forState:UIControlStateNormal];
    [contentView addSubview:placeholderBtn];
    [placeholderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-8.0);
        make.bottom.equalTo(contentView.mas_bottom).offset(-8.0);
    }];
    placeholderBtn.hidden = YES;
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"mg_room_btn_shan_n"] forState:UIControlStateNormal];
#pragma mark Action - 打开/关闭美颜效果
    [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        self.session.beautyFace = !self.session.beautyFace;
    }];
    [contentView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(placeholderBtn.mas_left).offset(-8.0);
        make.centerY.equalTo(placeholderBtn.mas_centerY);
    }];
    
    UIButton *audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioBtn setImage:[UIImage imageNamed:@"mg_room_btn_yinyue_h"] forState:UIControlStateNormal];
#pragma mark Action - 打开/关闭声音
    [[audioBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        self.session.muted = !self.session.muted;
    }];
    [contentView addSubview:audioBtn];
    [audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moreBtn.mas_left).offset(-8.0);
        make.centerY.equalTo(placeholderBtn.mas_centerY);
    }];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"mg_room_btn_xinxi_h"] forState:UIControlStateNormal];
#pragma mark Action - 信息
    [[messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    [contentView addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(audioBtn.mas_left).offset(-8.0);
        make.centerY.equalTo(placeholderBtn.mas_centerY);
    }];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setImage:[UIImage imageNamed:@"mg_room_btn_liao_h"] forState:UIControlStateNormal];
#pragma mark Action - 聊天
    [[chatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        
    }];
    [contentView addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(8.0);
        make.centerY.equalTo(placeholderBtn.mas_centerY);
    }];
    
    UIButton *toggleCaptureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleCaptureBtn setImage:[UIImage imageNamed:@"shortvideo_icon_down_switch"] forState:UIControlStateNormal];
#pragma mark Action - 切换摄像头
    [[toggleCaptureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
        self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    }];
    [contentView addSubview:toggleCaptureBtn];
    [toggleCaptureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(placeholderBtn.mas_centerX);
        make.bottom.equalTo(placeholderBtn.mas_top).offset(-8.0);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"mg_room_btn_guan_h"] forState:UIControlStateNormal];
#pragma mark Action - 返回
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-8.0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-8.0);
    }];
}

#pragma mark 捕获音视频
- (void)setupCaputure
{
    if ([UIDevice currentDevice].isSimulator) {
        return;
    }
    
    /*** 视频：分辨率： 540 *960 帧数：24 码率：800Kps  音频：高音频质量 audio sample rate: 48MHz, audio bitrate: 128Kbps  方向竖屏 ***/
    _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality:LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2]];
    
    /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
    /*
     LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
     audioConfiguration.numberOfChannels = 2;
     audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
     audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
     
     LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
     videoConfiguration.videoSize = CGSizeMake(720, 1280);
     videoConfiguration.videoBitRate = 800*1024;
     videoConfiguration.videoMaxBitRate = 1000*1024;
     videoConfiguration.videoMinBitRate = 500*1024;
     videoConfiguration.videoFrameRate = 15;
     videoConfiguration.videoMaxKeyframeInterval = 30;
     videoConfiguration.orientation = UIInterfaceOrientationPortrait;
     videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
     
     _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
     */
    
    _session.delegate = self;
    _session.running = YES;
    _session.beautyFace = YES;
    _session.preView = self.captureVideoPreview;
#ifdef DEBUG 
    _session.showDebugInfo = YES;
#else
    _session.showDebugInfo = NO;
#endif
    
    _streamInfo = [[LFLiveStreamInfo alloc] init];
    _streamInfo.url = self.viewModel.rtmpUrl;
}

- (UIView *)captureVideoPreview
{
    if (!_captureVideoPreview) {
        UIView *captureVideoPreview = [[UIView alloc] initWithFrame:self.view.bounds];
        _captureVideoPreview = captureVideoPreview;
        captureVideoPreview.backgroundColor = [UIColor clearColor];
        captureVideoPreview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:captureVideoPreview atIndex:0];
    }
    return _captureVideoPreview;
}

#pragma mark - HandleAction
#pragma mark 拖动内容视图
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _panGestureOffsetX = self.contentView.left;
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        if (self.contentView.left <= 0 && translation.x < 0) {
            return;
        }else if (self.contentView.left >= self.view.width && translation.x > 0) {
            return;
        }
        self.contentView.left += translation.x;
        
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat X;
        if (self.contentView.left - _panGestureOffsetX > 0) {
            if (self.contentView.left >= self.view.width / 4) {
                X = self.view.width;
            }else {
                X = 0;
            }
        }else {
            if (self.contentView.left <= self.view.width * 3 / 4) {
                X = 0;
            }else {
                X = self.view.width;
            }
        }
        NSTimeInterval duration = ABS(X - self.contentView.left) / self.view.width / 2;
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut animations:^{
            self.contentView.left = X;
        } completion:NULL];
    }
}

#pragma mark - LFStreamingSessionDelegate

/** live status changed will callback */
- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state
{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    DDLogInfo(@"%@", [NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.streamInfo.url]);
}

/** live debug info callback */
- (void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo
{
    
}

/** callback socket errorcode */
- (void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode
{
    NSString *tempStatus;
    switch (errorCode) {
        case LFLiveSocketError_PreView:
            tempStatus = @"预览失败";
            break;
        case LFLiveSocketError_GetStreamInfo:
            tempStatus = @"获取流媒体信息失败";
            break;
        case LFLiveSocketError_ConnectSocket:
            tempStatus = @"连接socket失败";
            break;
        case LFLiveSocketError_Verification:
            tempStatus = @"验证服务器失败";
            break;
        case LFLiveSocketError_ReConnectTimeOut:
            tempStatus = @"重新连接服务器超时";
            break;
        default:
            break;
    }
    DDLogError(@"%@", [NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.streamInfo.url]);
}

#pragma mark - Others

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
