//
//  LiveMetaModel.m
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveMetaModel.h"

@implementation LiveMetaModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc":@"description", @"type_id":@"typeid"};
}

@end
