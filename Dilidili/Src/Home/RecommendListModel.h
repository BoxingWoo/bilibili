//
//  RecommendListModel.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendModel.h"
#import "BannerModel.h"

extern NSString *const RecommendTypeRecommend;
extern NSString *const RecommendTypeLive;
extern NSString *const RecommendTypeBangumi;
extern NSString *const RecommendTypeRegion;
extern NSString *const RecommendTypeActivity;

extern NSString *const RecommendStyleLarge;
extern NSString *const RecommendStyleMedium;
extern NSString *const RecommendStyleSmall;

/**
 *  @brief 推荐列表模型
 */
@interface RecommendListModel : NSObject

/** 标识  */
@property (nonatomic, copy) NSString *param;
/** 分类 */
@property (nonatomic, copy) NSString *type;
/** 展示风格 */
@property (nonatomic, copy) NSString *style;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容数组 */
@property (nonatomic, copy) NSArray<RecommendModel *> *body;
/** 头部广告数组 */
@property (nonatomic, copy) NSArray<BannerModel *> *bannerTop;
/** 尾部广告数组 */
@property (nonatomic, copy) NSArray<BannerModel *> *bannerBottom;
/** 附件信息 */
@property (nonatomic, copy) NSDictionary *ext;

@end
