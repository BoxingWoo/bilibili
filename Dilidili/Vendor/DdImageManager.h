//
//  DdImageManager.h
//  Dilidili
//
//  Created by iMac on 16/9/1.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat kCoverCornerRadius = 8.0;  // 封面图片圆角

/**
 图片效果样式

 - DdImageStyleNone: 不添加效果
 - DdImageDarkGradient: 添加黑色渐变效果
 */
typedef NS_ENUM(NSInteger, DdImageStyle) {
    DdImageStyleNone = 0,
    DdImageDarkGradient = 1,
};

/**
 dilidili图片工具
 */
@interface DdImageManager : NSObject

/**
 头像占位图片

 @return 头像占位图片
 */
+ (UIImage *)face_placeholderImage;

/**
 封面占位图片

 @param size 大小
 @return 封面占位图片
 */
+ (UIImage *)cover_placeholderImageBySize:(CGSize)size;

/**
 直播封面占位图片

 @param size 大小
 @return 直播封面占位图片
 */
+ (UIImage *)live_placeholderImageBySize:(CGSize)size;

/**
 活动封面占位图片

 @param size 大小
 @return 活动封面占位图片
 */
+ (UIImage *)activity_placeholderImageBySize:(CGSize)size;

/**
 横幅广告占位图片

 @param size 大小
 @return 横幅广告占位图片
 */
+ (UIImage *)banner_placeholderImageBySize:(CGSize)size;

/**
 转化图片

 @param originImage 原图
 @param size 大小
 @param radius 圆角
 @param style 图片效果样式
 @return 效果图
 */
+ (UIImage *)transformImage:(UIImage *)originImage size:(CGSize)size cornerRadius:(CGFloat)radius style:(DdImageStyle)style;

@end
