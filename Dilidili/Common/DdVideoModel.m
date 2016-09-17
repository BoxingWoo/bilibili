//
//  DdVideoModel.m
//  Dilidili
//
//  Created by iMac on 16/9/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoModel.h"

@implementation DdVideoModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"relates":DdRelativeVideoModel.class};
}

@end
