//
//  LiveCaptureViewController.m
//  Dilidili
//
//  Created by iMac on 2016/10/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LiveCaptureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    CGFloat _panGestureOffsetX;
}

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *currentVideoDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *currentAudioDeviceInput;
@property (nonatomic, weak) UIImageView *focusCursorImageView;
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, weak) AVCaptureConnection *videoConnection;

@end

@implementation LiveCaptureViewController

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
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.captureSession stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)createUI
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
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
#pragma mark Action - 更多
    [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {

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
        x.selected = !x.isSelected;
        if (x.isSelected) {
            [self.captureSession removeInput:self.currentAudioDeviceInput];
        }else {
            AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
            AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice: audioDevice error:nil];
            [self.captureSession addInput:audioDeviceInput];
            self.currentAudioDeviceInput = audioDeviceInput;
        }
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
    [toggleCaptureBtn addTarget:self action:@selector(handleToggleCapture:) forControlEvents:UIControlEventTouchUpInside];
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
    
    // 1.创建捕获会话,必须要强引用，否则会被释放
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    _captureSession = captureSession;
    
    // 2.获取摄像头设备，默认是后置摄像头
    AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];
    
    // 3.获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    // 4.创建对应视频设备输入对象
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    _currentVideoDeviceInput = videoDeviceInput;
    
    // 5.创建对应音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    _currentAudioDeviceInput = audioDeviceInput;
    
    // 6.添加到会话中
    // 注意“最好要判断是否能添加输入，会话不能添加空的
    // 6.1 添加视频
    if ([captureSession canAddInput:videoDeviceInput]) {
        [captureSession addInput:videoDeviceInput];
    }
    // 6.2 添加音频
    if ([captureSession canAddInput:audioDeviceInput]) {
        [captureSession addInput:audioDeviceInput];
    }
    
    // 7.获取视频数据输出设备
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    // 7.1 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    if ([captureSession canAddOutput:videoOutput]) {
        [captureSession addOutput:videoOutput];
    }
    
    // 8.获取音频数据输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    // 8.2 设置代理，捕获音频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([captureSession canAddOutput:audioOutput]) {
        [captureSession addOutput:audioOutput];
    }
    
    // 9.获取视频输入与输出连接，用于分辨音视频数据
    _videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 10.添加视频预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    _previewLayer = previewLayer;
}

- (UIImageView *)focusCursorImageView
{
    if (!_focusCursorImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"capture_focus"]];
        _focusCursorImageView = imageView;
        [self.view addSubview:_focusCursorImageView];
    }
    return _focusCursorImageView;
}

#pragma mark - Utility
#pragma mark 指定摄像头方向获取摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark 设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorImageView.center = point;
    self.focusCursorImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorImageView.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha = 0;
    }];
}

#pragma mark 设置聚焦
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    AVCaptureDevice *captureDevice = self.currentVideoDeviceInput.device;
    // 锁定配置
    [captureDevice lockForConfiguration:nil];
    
    // 设置聚焦
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    
    // 设置曝光
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    
    // 解锁配置
    [captureDevice unlockForConfiguration];
}


#pragma mark - HandleAction
#pragma mark 点击屏幕聚焦
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    // 获取点击位置
    CGPoint point = [tap locationInView:tap.view];
    
    // 把当前位置转换为摄像头点上的位置
    CGPoint cameraPoint = [_previewLayer captureDevicePointOfInterestForPoint:point];
    
    // 设置聚焦点光标位置
    [self setFocusCursorWithPoint:point];
    
    // 设置聚焦
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

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

#pragma mark 切换摄像头
- (void)handleToggleCapture:(UIButton *)sender
{
    // 获取当前设备方向
    AVCaptureDevicePosition curPosition = _currentVideoDeviceInput.device.position;
    
    // 获取需要改变的方向
    AVCaptureDevicePosition togglePosition = curPosition == AVCaptureDevicePositionFront ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    
    // 获取改变的摄像头设备
    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];
    
    // 获取改变的摄像头输入设备
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];
    
    // 移除之前摄像头输入设备
    [self.captureSession removeInput:self.currentVideoDeviceInput];
    
    // 添加新的摄像头输入设备
    [self.captureSession addInput:toggleDeviceInput];
    
    // 记录当前摄像头输入设备
    self.currentVideoDeviceInput = toggleDeviceInput;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// 获取输入设备数据，有可能是音频有可能是视频
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.videoConnection == connection) {
        
    }else {
        
    }
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
