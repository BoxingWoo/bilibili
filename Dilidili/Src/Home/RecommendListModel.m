//
//  RecommendListModel.m
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendListModel.h"

@implementation RecommendListModel

NSString *const RecommendTypeRecommend = @"recommend";
NSString *const RecommendTypeLive = @"live";
NSString *const RecommendTypeBangumi = @"bangumi";
NSString *const RecommendTypeRegion = @"region";
NSString *const RecommendTypeActivity = @"activity";

NSString *const RecommendStyleLarge = @"large";
NSString *const RecommendStyleMedium = @"medium";
NSString *const RecommendStyleSmall = @"small";

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"body":RecommendModel.class, @"bannerTop":BannerModel.class, @"bannerBottom":BannerModel.class};
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"bannerTop":@"banner.top", @"bannerBottom":@"banner.bottom"};
}

@end
