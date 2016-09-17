//
//  DdVideoReplySectionFooter.m
//  Dilidili
//
//  Created by BoxingWoo on 16/9/17.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoReplySectionFooter.h"

@implementation DdVideoReplySectionFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled = NO;
        self.contentView.backgroundColor = kBorderColor;
    }
    return self;
}

@end
