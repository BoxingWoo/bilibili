//
//  DdBufferProgressView.m
//  Dilidili
//
//  Created by iMac on 16/9/10.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdBufferProgressView.h"
#import <pop/POP.h>

#define kBufferProgressViewSize CGSizeMake(148.0, 26.0)

@interface DdBufferProgressView ()

@property (nonatomic, weak) UIImageView *animateImageView;
@property (nonatomic, weak) UILabel *progressLabel;

@end

@implementation DdBufferProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect
{
    if (self = [super initWithEffect:effect]) {
        self.frame = CGRectMake(0, 0, kBufferProgressViewSize.width, kBufferProgressViewSize.height);
        UIImageView *animateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_loading"]];
        _animateImageView = animateImageView;
        [animateImageView sizeToFit];
        animateImageView.left = 4.0;
        animateImageView.centerY = self.height / 2;
        [self.contentView addSubview:animateImageView];
        
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(animateImageView.right + 4.0, 0, self.width - animateImageView.right - 4.0, self.height)];
        _progressLabel = progressLabel;
        progressLabel.font = [UIFont systemFontOfSize:13];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.text = @"正在缓冲：0%";
        [self.contentView addSubview:progressLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, kBufferProgressViewSize.width, kBufferProgressViewSize.height)];
}

- (CGSize)intrinsicContentSize
{
    return kBufferProgressViewSize;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.duration = 0.8;
    animation.repeatForever = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    [self.animateImageView.layer pop_addAnimation:animation forKey:@"buffer_rotation"];
}

- (void)removeFromSuperview
{
    [self.animateImageView.layer pop_removeAnimationForKey:@"buffer_rotation"];
    [super removeFromSuperview];
}

- (void)setBufferingProgress:(NSInteger)bufferingProgress
{
    if (bufferingProgress > 99) {
        _bufferingProgress = 99;
    }else if (bufferingProgress < 0) {
        _bufferingProgress = 0;
    }else {
        _bufferingProgress = bufferingProgress;
    }
    self.progressLabel.text = [NSString stringWithFormat:@"正在缓冲：%li%%", _bufferingProgress];
}

@end
