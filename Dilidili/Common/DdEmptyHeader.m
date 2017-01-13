//
//  DdEmptyHeader.m
//  Dilidili
//
//  Created by iMac on 2016/11/18.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdEmptyHeader.h"

@implementation DdEmptyHeader

- (void)prepare
{
    [super prepare];
    
    self.backgroundColor = kThemeColor;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.mj_w = self.scrollView.mj_w;
    self.mj_h = self.scrollView.mj_h;
    self.mj_y = - self.mj_h + self.scrollView.layer.cornerRadius;
}

@end
