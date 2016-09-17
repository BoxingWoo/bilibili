//
//  DdReplyContentModel.m
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdReplyContentModel.h"

@implementation DdReplyContentModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"members":DdUserModel.class};
}

@end
