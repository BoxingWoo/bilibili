//
//  DdReplyModel.m
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdReplyModel.h"

@implementation DdReplyModel

- (instancetype)init
{
    if (self = [super init]) {
        _isliked = NO;
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"replies":DdReplyModel.class};
}

@end
