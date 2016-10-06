//
//  LivePartitionModel.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LivePartitionModel.h"

@implementation LivePartitionModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"partition_id":@"id"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDictionary *sub_icon = dic[@"sub_icon"];
    _src = sub_icon[@"src"];
    return YES;
}

@end
