//
//  MineContentView.m
//  Dilidili
//
//  Created by iMac on 2016/11/17.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdCornerView.h"

@implementation DdCornerView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6.0, 6.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
