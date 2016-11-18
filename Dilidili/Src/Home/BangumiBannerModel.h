//
//  BangumiBannerModel.h
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 番剧横幅广告模型
 */
@interface BangumiBannerModel : NSObject

/**
 标识
 */
@property (nonatomic, assign) NSInteger banner_id;
/**
 图片
 */
@property (nonatomic, copy) NSString *img;
/**
 索引
 */
@property (nonatomic, assign) NSInteger index;
/**
 是否广告
 */
@property (nonatomic, assign) BOOL is_ad;
/**
 链接
 */
@property (nonatomic, copy) NSString *link;
/**
 发布时间
 */
@property (nonatomic, copy) NSString *pub_time;
/**
 标题
 */
@property (nonatomic, copy) NSString *title;

@end
