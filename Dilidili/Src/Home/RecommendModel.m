//
//  RecommendModel.m
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"go":@"goto"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *pic = [dic objectForKey:@"pic"];
    if ([pic isNotBlank]) {
        _cover = pic;
    }
    NSUInteger video_review = [[dic objectForKey:@"video_review"] unsignedIntegerValue];
    if (video_review != 0) {
        _danmaku = video_review;
    }
    NSString *aid = [[dic objectForKey:@"aid"] stringValue];
    if ([aid isNotBlank]) {
        _param = aid;
    }
    NSString *mid = [[dic objectForKey:@"mid"] stringValue];
    if ([mid isNotBlank]) {
        _uri = [NSString stringWithFormat:@"bilibili://video/%@", mid];
    }
    return YES;
}

@end
