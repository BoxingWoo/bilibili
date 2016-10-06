//
//  DdDanmakuViewController.m
//  Dilidili
//
//  Created by iMac on 2016/9/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdDanmakuViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "DdDanmakuUserDefaults.h"
#import "DdDanmakuViewModel.h"

@interface DdDanmakuViewController () <BarrageRendererDelegate>

/**
 定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 当前同屏弹幕数量
 */
@property (nonatomic, weak) UILabel *currentDanmakusCountLabel;

/**
 弹幕视图模型数组
 */
@property (nonatomic, strong) NSMutableArray <DdDanmakuViewModel *> *dataArr;

@end

@implementation DdDanmakuViewController

#pragma mark - LifeCycle

- (instancetype)init
{
    if (self = [super init]) {
        _renderer = [[BarrageRenderer alloc] init];
        _renderer.delegate = self;
        _renderer.canvasMargin = UIEdgeInsetsZero;
        _renderer.redisplay = NO;
        @weakify(self);
        [[[DdDanmakuUserDefaults sharedInstance] rac_valuesForKeyPath:@"speed" observer:self] subscribeNext:^(id x) {
            @strongify(self);
            self.renderer.speed = [x doubleValue] * 1 / 7.5;
        }];
        _shouldHideDanmakus = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.renderer.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self installMovieNotificationObservers];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    [self.renderer stop];
    [self removeMovieNotificationObservers];
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

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(loadDanmakus:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UILabel *)currentDanmakusCountLabel
{
    if (!_currentDanmakusCountLabel) {
        UILabel *currentDanmakusCountLabel = [[UILabel alloc] init];
        _currentDanmakusCountLabel = currentDanmakusCountLabel;
        currentDanmakusCountLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        currentDanmakusCountLabel.font = [UIFont fontWithName:@"Menlo" size:14];
        currentDanmakusCountLabel.textAlignment = NSTextAlignmentCenter;
        currentDanmakusCountLabel.textColor = [UIColor whiteColor];
        currentDanmakusCountLabel.layer.cornerRadius = 5.0;
        currentDanmakusCountLabel.layer.masksToBounds = YES;
        [self.view addSubview:currentDanmakusCountLabel];
        [currentDanmakusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(5.0);
            make.top.equalTo(self.view.mas_top).offset(60.0);
            make.height.mas_equalTo(20.0);
            make.width.mas_greaterThanOrEqualTo(156.0);
        }];
    }
    return _currentDanmakusCountLabel;
}

#pragma mark - Setter

- (void)setShouldHideDanmakus:(BOOL)shouldHideDanmakus
{
    _shouldHideDanmakus = shouldHideDanmakus;
    if (shouldHideDanmakus) {
        [self.timer invalidate];
        self.timer = nil;
        [self.renderer stop];
        [_currentDanmakusCountLabel removeFromSuperview];
    }else {
        [self.renderer start];
        self.renderer.speed = [DdDanmakuUserDefaults sharedInstance].speed * 1 / 7.5;
        [self.timer setFireDate:[NSDate date]];
    }
}

#pragma mark - Utility
#pragma mark 配置通知中心
- (void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
}

#pragma mark 移除通知中心
- (void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

- (void)moviePlayBackStateDidChange:(NSNotification *)notification
{
    switch (_delegatePlayer.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            [self.timer invalidate];
            self.timer = nil;
            [self.renderer stop];
            [_currentDanmakusCountLabel removeFromSuperview];
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            if (!self.shouldHideDanmakus) {
                [self.renderer start];
                self.renderer.speed = [DdDanmakuUserDefaults sharedInstance].speed * 1 / 7.5;
                [self.timer setFireDate:[NSDate date]];
            }
            break;
        }
        case IJKMPMoviePlaybackStatePaused:
        case IJKMPMoviePlaybackStateInterrupted:
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            if (!self.shouldHideDanmakus) {
                [self.timer setFireDate:[NSDate distantFuture]];
                [self.renderer pause];
            }
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark 请求弹幕数据
- (RACSignal *)requestData
{
    RACSignal *signal = [[DdDanmakuViewModel requestDanmakuDataByCid:self.cid] execute:nil];
    [signal subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSArray *models, NSNumber *maxlimit) = tuple;
        DDLogInfo(@"视频弹幕总数：%@", maxlimit);
        self.dataArr = [[NSMutableArray alloc] init];
        for (DdDanmakuModel *model in models) {
            DdDanmakuViewModel *viewModel = [[DdDanmakuViewModel alloc] initWithModel:model];
            [self.dataArr addObject:viewModel];
        }
    }];
    return signal;
}

#pragma mark - 加载弹幕
- (void)loadDanmakus:(NSTimer *)timer
{
    DdDanmakuUserDefaults *danmakuUserDefaults = [DdDanmakuUserDefaults sharedInstance];
    NSUInteger screenMaxlimit = danmakuUserDefaults.screenMaxlimit;
    NSInteger currentDanmakusCount = [self.renderer spritesNumberWithName:nil];
#ifdef DEBUG
    CGFloat progress = 0.0;
    if (screenMaxlimit != 0) {
        progress = (CGFloat)currentDanmakusCount / (CGFloat)screenMaxlimit;
    }
    UIColor *color = [UIColor colorWithHue:0.27 * (0.8 - progress) saturation:1 brightness:0.9 alpha:1];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前屏幕弹幕数量: %li", currentDanmakusCount]];
    [text setColor:color range:NSMakeRange(10, text.length - 10)];
    self.currentDanmakusCountLabel.attributedText = text;
#endif
    
    if (currentDanmakusCount >= screenMaxlimit) {  //屏蔽超出最大同屏数弹幕
        return;
    }
    NSTimeInterval currentPlaybackTime = self.delegatePlayer.currentPlaybackTime;
    NSMutableArray *descriptors = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        DdDanmakuViewModel *viewModel = self.dataArr[i];
        if (viewModel.model.delay >= currentPlaybackTime && viewModel.model.delay < currentPlaybackTime + timer.timeInterval) {
            BOOL isShielded = NO;
            if ((danmakuUserDefaults.shieldingOption & DdDanmakuShieldingFloatTop) && viewModel.model.style == DdDanmakuFloatTop) {  //屏蔽顶部弹幕
                isShielded = YES;
            }
            if ((danmakuUserDefaults.shieldingOption & DdDanmakuShieldingWalk) && (viewModel.model.style == DdDanmakuWalkL2R || viewModel.model.style == DdDanmakuWalkR2L)) {  //屏蔽滚动弹幕
                isShielded = YES;
            }
            if ((danmakuUserDefaults.shieldingOption & DdDanmakuShieldingFloatBottom) && viewModel.model.style == DdDanmakuFloatBottom) {  //屏蔽底部弹幕
                isShielded = YES;
            }
            if ((danmakuUserDefaults.shieldingOption & DdDanmakuShieldingColorful) && viewModel.model.textColorValue != DdDanmakuWhite) {  //屏蔽彩色弹幕
                isShielded = YES;
            }
            
            if (!isShielded) {  //派发弹幕
                [descriptors addObject:viewModel.descriptor];
            }
        }
    }
    [self.renderer load:descriptors];
}

#pragma mark - BarrageRendererDelegate

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    return self.delegatePlayer.currentPlaybackTime;
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
