//
//  LiveFilterCaptureViewController.m
//  Dilidili
//
//  Created by iMac on 2016/10/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveFilterCaptureViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"

@interface LiveFilterCaptureViewController () <GPUImageVideoCameraDelegate>
{
    CGFloat _panGestureOffsetX;
    BOOL _isAddedFilter;
}

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIImageView *focusCursorImageView;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, weak) GPUImageView *captureVideoPreview;

@end

@implementation LiveFilterCaptureViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBgColor;
    
    _isAddedFilter = NO;
    
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
    [self.videoCamera startCameraCapture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.videoCamera stopCameraCapture];
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
    [moreBtn addTarget:self action:@selector(handleSettingFilter) forControlEvents:UIControlEventTouchUpInside];
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
            [self.videoCamera removeAudioInputsAndOutputs];
        }else {
            [self.videoCamera addAudioInputsAndOutputs];
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
#pragma mark Action - 切换摄像头
    [[toggleCaptureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.videoCamera rotateCamera];
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
    
    // 创建视频源
    // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
    // cameraPosition:摄像头方向
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [videoCamera addAudioInputsAndOutputs];
    _videoCamera = videoCamera;
    
    // 创建最终预览View
    GPUImageView *captureVideoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:captureVideoPreview atIndex:0];
    captureVideoPreview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _captureVideoPreview = captureVideoPreview;
    
    // 添加美颜滤镜
    [self handleSettingFilter];
    
    // 必须调用startCameraCapture，底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
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
    AVCaptureDevice *captureDevice = self.videoCamera.inputCamera;
    
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
#pragma mark 设置滤镜
- (void)handleSettingFilter
{
    // 切换美颜效果原理：移除之前所有处理链，重新设置处理链
    if (!_isAddedFilter) {
        
        // 移除之前所有处理链
        [self.videoCamera removeAllTargets];
        
        // 创建美颜滤镜
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        
        // 设置GPUImage处理链，从数据源 => 滤镜 => 最终界面效果
        [self.videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.captureVideoPreview];
        
    }else {
        // 移除之前所有处理链
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.captureVideoPreview];
    }
    
    _isAddedFilter = !_isAddedFilter;
}

#pragma mark 点击屏幕聚焦
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    // 获取点击位置
    CGPoint point = [tap locationInView:tap.view];
    
    // 把当前位置转换为摄像头点上的位置
    CGPoint cameraPoint = [tap.view convertPoint:point toView:self.captureVideoPreview];
    
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

#pragma mark - GPUImageVideoCameraDelegate

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    
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
