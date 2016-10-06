//
//  DdRefreshNormalHeader.m
//  Dilidili
//
//  Created by iMac on 16/9/18.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdRefreshNormalHeader.h"

@interface DdRefreshNormalHeader ()

@property (nonatomic, weak) UIImageView *animateImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *arrowImageView;
@property (nonatomic, weak) UIActivityIndicatorView *loading;
@property (nonatomic, strong) NSMutableArray *animateImages;

@end

@implementation DdRefreshNormalHeader

- (NSMutableArray *)animateImages
{
    if (!_animateImages) {
        _animateImages = [NSMutableArray array];
        for (int i = 1; i <= 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_logo_%d",i]];
            [_animateImages addObject:image];
        }
    }
    return _animateImages;
}

- (void)prepare
{
    [super prepare];
    
    //设置控件的高度
    self.mj_h = 88;
    
    //添加子控件
    //animateImageView
    UIImageView *animateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_logo_1"]];
    _animateImageView = animateImageView;
    animateImageView.contentMode = UIViewContentModeScaleAspectFit;
    animateImageView.animationImages = self.animateImages;
    [self addSubview:animateImageView];
    
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    titleLabel.textColor = kTextColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"再拉，再拉就刷给你看";
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    
    //arrow
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    _arrowImageView = arrowImageView;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:arrowImageView];
    
    //loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loading = loading;
    [self addSubview:loading];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    _animateImageView.centerX = self.mj_w * 0.5;
    _animateImageView.top = 6;
    
    _arrowImageView.top = _animateImageView.bottom - 2;
    _arrowImageView.right = _animateImageView.left + 14;
    
    _loading.center = _arrowImageView.center;
    
    _titleLabel.left = _arrowImageView.right + 2;
    _titleLabel.top = _animateImageView.bottom + 6;
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state == MJRefreshStateIdle) {
        
        CGPoint offset = [change[@"new"] CGPointValue];
        
        if (offset.x == 0) {
            _titleLabel.text = @"再拉，再拉就刷给你看";
            [_titleLabel sizeToFit];
        }
    }
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    // 根据状态做事情
    switch (state) {
        case MJRefreshStateIdle:
        {
            if (oldState == MJRefreshStateRefreshing) {
                _arrowImageView.transform = CGAffineTransformIdentity;
                _titleLabel.text = @"刷呀刷呀，刷完啦，喵^ω^";
                [_titleLabel sizeToFit];
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    _loading.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                    if (self.state != MJRefreshStateIdle) return;
                    _loading.alpha = 1.0;
                    [_loading stopAnimating];
                    [_animateImageView stopAnimating];
                    _arrowImageView.hidden = NO;
                }];
            } else {
                _titleLabel.text = @"再拉，再拉就刷给你看";
                [_titleLabel sizeToFit];
                [_loading stopAnimating];
                [_animateImageView stopAnimating];
                _arrowImageView.hidden = NO;
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    _arrowImageView.transform = CGAffineTransformIdentity;
                }];
            }
            
            break;
        }
        case MJRefreshStatePulling:
        {
            [_loading stopAnimating];
            _arrowImageView.hidden = NO;
            _titleLabel.text = @"够了啦，松开人家嘛";
            [_titleLabel sizeToFit];
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            break;
        }
        case MJRefreshStateRefreshing:
        {
            _loading.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
            [_loading startAnimating];
            _arrowImageView.hidden = YES;
            [_animateImageView startAnimating];
            _titleLabel.text = @"刷呀刷呀，好累啊，喵^ω^";
            [_titleLabel sizeToFit];
            break;
        }
        default:
            break;
    }
}

@end
