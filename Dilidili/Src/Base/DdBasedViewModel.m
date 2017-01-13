//
//  DdBasedViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"

@implementation DdBasedViewModel

- (instancetype)initWithClassName:(NSString *)className params:(NSDictionary *)params
{
    if (self = [self init]) {
        _className = className;
        _params = params;
    }
    return self;
}

@end
