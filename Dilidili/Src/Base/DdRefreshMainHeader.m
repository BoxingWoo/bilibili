//
//  DdRefreshMainHeader.m
//  Dilidili
//
//  Created by iMac on 2016/9/22.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdRefreshMainHeader.h"

@interface DdRefreshMainHeader ()
{
    CGFloat _normal2pullingHeight;
    CGFloat _insetTDelta;
}

@property (nonatomic, weak) UILabel *pullingLabel;
@property (nonatomic, weak) UIView *refreshingView;
@property (nonatomic, weak) UIImageView *refreshingImageView;
@property (nonatomic, weak) UILabel *refreshingLabel;

@end

@implementation DdRefreshMainHeader

#pragma mark - 构造方法
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    DdRefreshMainHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    DdRefreshMainHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    //设置普通和即将刷新的控件临界高度
    _normal2pullingHeight = 96.0;
    
    //设置背景颜色
    self.backgroundColor = kThemeColor;
    
    //添加子控件
    UIView *refreshingView = [[UIView alloc] init];
    _refreshingView = refreshingView;
    [self addSubview:refreshingView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:refreshingView.bounds];
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundImageView.image = [[UIImage imageWithColor:kBgColor size:CGSizeMake(kScreenWidth, 44.0)] imageByRoundCornerRadius:6.0 corners:UIRectCornerTopLeft | UIRectCornerTopRight borderWidth:0.0 borderColor:nil borderLineJoin:0];
    [refreshingView addSubview:backgroundImageView];
    
    NSMutableArray *refreshingImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"common_rabbitBar_face%d", i]];
        [refreshingImages addObject:image];
    }
    UIImageView *refreshingImageView = [[UIImageView alloc] init];
    _refreshingImageView = refreshingImageView;
    refreshingImageView.contentMode = UIViewContentModeScaleAspectFit;
    refreshingImageView.animationImages = refreshingImages;
    refreshingImageView.animationDuration = refreshingImages.count * 0.5;
    [refreshingView addSubview:refreshingImageView];
    
    UILabel *refreshingLabel = [[UILabel alloc] init];
    _refreshingLabel = refreshingLabel;
    refreshingLabel.font = [UIFont systemFontOfSize:11];
    refreshingLabel.textColor = [UIColor lightGrayColor];
    refreshingLabel.textAlignment = NSTextAlignmentCenter;
    refreshingLabel.text = @"正在更新...";
    [refreshingLabel sizeToFit];
    [refreshingView addSubview:refreshingLabel];
    
    UILabel *pullingLabel = [[UILabel alloc] init];
    _pullingLabel = pullingLabel;
    pullingLabel.font = [UIFont systemFontOfSize:12];
    pullingLabel.textColor = [UIColor whiteColor];
    pullingLabel.textAlignment = NSTextAlignmentCenter;
    pullingLabel.text = @"再用力点!";
    [pullingLabel sizeToFit];
    [self addSubview:pullingLabel];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.mj_w = self.scrollView.mj_w;
    self.mj_h = self.scrollView.mj_h;
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
    
    self.refreshingView.mj_w = self.mj_w;
    self.refreshingView.mj_h = 44.0;
    self.refreshingView.mj_y = self.mj_h - self.refreshingView.mj_h;
    
    self.refreshingImageView.mj_w = self.refreshingView.mj_w;
    self.refreshingImageView.mj_h = 30.0;
    
    self.refreshingLabel.mj_w = self.refreshingView.mj_w;
    self.refreshingLabel.mj_y = self.refreshingView.mj_h - self.refreshingLabel.mj_h - 6.0;
    
    self.pullingLabel.mj_w = self.mj_w;
    self.pullingLabel.mj_y = self.mj_h - self.refreshingView.mj_h - self.pullingLabel.mj_h - 20.0;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.state == MJRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mj_insetT = insetT;
        
        _insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - _normal2pullingHeight;
    CGFloat pullingPercent = (happenOffsetY - self.refreshingView.mj_h - offsetY) / (_normal2pullingHeight - self.refreshingView.mj_h);
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            // 恢复inset和offset
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.scrollView.mj_insetT += _insetTDelta;
                
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
                
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
            }];
        }

        [self.refreshingImageView stopAnimating];
        self.refreshingImageView.hidden = YES;
        self.refreshingLabel.hidden = YES;
        self.pullingLabel.text = @"再用力点!";
        
    }else if (state == MJRefreshStatePulling) {
        
        self.pullingLabel.text = @"松手加载";
        
    }else if (state == MJRefreshStateRefreshing) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + _normal2pullingHeight - self.refreshingView.mj_h;
                // 增加滚动区域top
                self.scrollView.mj_insetT = top;
                // 设置滚动位置
                [self.scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        });
        
        self.refreshingImageView.hidden = NO;
        self.refreshingLabel.hidden = NO;
        [self.refreshingImageView startAnimating];
        
    }
}

#pragma mark - 公共方法
- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MJRefreshStateIdle;
    });
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    self.pullingLabel.alpha = pullingPercent;
}

@end
