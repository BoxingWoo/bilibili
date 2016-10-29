//
//  LiveGiftModel.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播礼物模型
 */
@interface LiveGiftModel : NSObject

/**
 礼物ID
 */
@property (nonatomic, assign) NSInteger gift_id;
/**
 礼物名称
 */
@property (nonatomic, copy) NSString *name;
/**
 礼物价格
 */
@property (nonatomic, assign) float price;
/**
 硬币类型
 */
@property (nonatomic, copy) NSDictionary *coin_type;
/**
 礼物图片
 */
@property (nonatomic, copy) NSString *img;
/**
 礼物动态图链接
 */
@property (nonatomic, copy) NSString *gif_url;
/**
 礼物次数
 */
@property (nonatomic, copy) NSString *count_set;
/**
 礼物数量
 */
@property (nonatomic, assign) NSUInteger num;

@end
