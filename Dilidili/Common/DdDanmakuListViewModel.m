//
//  DdDanmakuListViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/11.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdDanmakuListViewModel.h"

@implementation DdDanmakuListViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(DdDanmakuModel *)model
{
    if (self = [super init]) {
        _model = model;
        BarrageDescriptor *descriptor = [[BarrageDescriptor alloc]init];
        _descriptor = descriptor;
        if (model.style == DdDanmakuWalkR2L || model.style == DdDanmakuWalkL2R) {
            descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
            NSNumber *direction = nil;
            switch (model.style) {
                case DdDanmakuWalkR2L:
                    direction = @(BarrageWalkDirectionR2L);
                    break;
                case DdDanmakuWalkL2R:
                    direction = @(BarrageWalkDirectionL2R);
                    break;
                default:
                    break;
            }
            descriptor.params[@"direction"] = direction;
            descriptor.params[@"side"] = @(BarrageWalkSideDefault);
            descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX + 50);
        }else {
            descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);
            NSNumber *direction = nil;
            switch (model.style) {
                case DdDanmakuFloatTop:
                    direction = @(BarrageFloatDirectionT2B);
                    break;
                case DdDanmakuFloatBottom:
                    direction = @(BarrageFloatDirectionB2T);
                    break;
                default:
                    direction = @(BarrageFloatDirectionT2B);
                    break;
            }
            descriptor.params[@"direction"] = direction;
            descriptor.params[@"side"] = @(BarrageFloatSideCenter);
            descriptor.params[@"duration"] = @(5.0);
        }
//        descriptor.params[@"delay"] = @(model.delay);
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:model.text];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:model.fontSize] range:NSMakeRange(0, model.text.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:model.textColor range:NSMakeRange(0, model.text.length)];
        CGFloat strokeWidth = [DdDanmakuUserDefaults sharedInstance].strokeWidth / kScreenScale;
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor blackColor];
        shadow.shadowOffset = CGSizeMake(strokeWidth, strokeWidth);
        [attributedText addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, model.text.length)];
        descriptor.params[@"attributedText"] = attributedText;
    }
    return self;
}

@end
