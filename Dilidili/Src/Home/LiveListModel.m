//
//  LiveListModel.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveListModel.h"

@implementation LiveListModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"lives":LiveModel.class, @"banner_data":LiveModel.class};
}

@end
