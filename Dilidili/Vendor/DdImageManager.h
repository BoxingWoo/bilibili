//
//  DdImageManager.h
//  Dilidili
//
//  Created by iMac on 16/9/1.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat kCoverCornerRadius = 8.0;

typedef NS_ENUM(NSInteger, DdImageStyle) {
    DdImageStyleNone = 0,
    DdImageDarkGradient = 1,
};

@interface DdImageManager : NSObject

+ (UIImage *)face_placeholderImage;

+ (UIImage *)cover_placeholderImageBySize:(CGSize)size;

+ (UIImage *)live_placeholderImageBySize:(CGSize)size;

+ (UIImage *)banner_placeholderImageBySize:(CGSize)size;

+ (UIImage *)transformImage:(UIImage *)originImage size:(CGSize)size cornerRadius:(CGFloat)radius style:(DdImageStyle)style;

@end
