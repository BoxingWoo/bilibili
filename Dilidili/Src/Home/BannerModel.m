//
//  BannerModel.m
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"banner_id":@"id", @"hashStr":@"hash"};
}

@end
