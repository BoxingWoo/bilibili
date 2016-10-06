//
//  LiveBannerModel.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DdOwnerModel.h"

/**
 直播横幅广告模型
 */
@interface LiveBannerModel : NSObject

/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 图片
 */
@property (nonatomic, copy) NSString *img;
/**
 评论
 */
@property (nonatomic, copy) NSString *remark;
/**
 链接
 */
@property (nonatomic, copy) NSString *link;

@end
