//
//  DdCollectionView.m
//  Dilidili
//
//  Created by iMac on 16/8/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdCollectionView.h"

@implementation DdCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(DdTableViewCornerRadius, DdTableViewCornerRadius)];
//        CAShapeLayer *mask = [CAShapeLayer layer];
//        mask.path = path.CGPath;
//        self.layer.mask = mask;
//        self.layer.masksToBounds = YES;
//        [path closePath];
        self.layer.cornerRadius = DdTableViewCornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
