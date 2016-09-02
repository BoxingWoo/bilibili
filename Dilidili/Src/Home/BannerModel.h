//
//  BannerModel.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 横幅广告模型
 */
@interface BannerModel : NSObject

/** ID */
@property (nonatomic, copy) NSString *banner_id;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 图片 */
@property (nonatomic, copy) NSString *image;
/** 哈希值 */
@property (nonatomic, copy) NSString *hashStr;
/** URI */
@property (nonatomic, copy) NSString *uri;

@end
