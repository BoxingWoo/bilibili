//
//  LiveModel.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveModel.h"

@implementation LiveModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDictionary *cover = dic[@"cover"];
    _cover = cover[@"src"];
    return YES;
}

@end
