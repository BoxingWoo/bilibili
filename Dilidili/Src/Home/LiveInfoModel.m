//
//  LiveInfoModel.m
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveInfoModel.h"

@implementation LiveInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"recommend":LiveModel.class, @"hot_word":LiveHotWordModel.class, @"roomgifts":LiveGiftModel.class, @"ignore_gift":LiveGiftModel.class, @"activity_gift":LiveGiftModel.class};
}

@end
