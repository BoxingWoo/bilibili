//
//  DdImageManager.m
//  Dilidili
//
//  Created by iMac on 16/9/1.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdImageManager.h"

@implementation DdImageManager

static NSString *const PlaceholderImageName = @"default_img";

+ (UIImage *)face_placeholderImage
{
    NSString *name = @"misc_avatarDefault";
    NSString *key = name.md5String;
    YYImageCache *imageCache = [YYImageCache sharedCache];
    UIImage *placeholderImage = [imageCache getImageForKey:key];
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:name];
        placeholderImage = [placeholderImage imageByRoundCornerRadius:placeholderImage.size.width / 2];
        [imageCache setImage:placeholderImage forKey:key];
    }
    return placeholderImage;
}

+ (UIImage *)cover_placeholderImageBySize:(CGSize)size
{
    NSString *key = [NSString stringWithFormat:@"cover_%@_%@", PlaceholderImageName, [NSValue valueWithCGSize:size]].md5String;
    YYImageCache *imageCache = [YYImageCache sharedCache];
    UIImage *placeholderImage = [imageCache getImageForKey:key];
    if (placeholderImage == nil) {
        UIImage *bgImage = [self _placeholderImageBySize:size];
        CGRect rect = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, kScreenScale);
        [bgImage drawInRect:rect];
        UIImage *gradientImage = [self _gradientImageWithRect:rect style:DdImageDarkGradient];
        [gradientImage drawInRect:rect];
        
        placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        placeholderImage = [placeholderImage imageByRoundCornerRadius:kCoverCornerRadius];
        [imageCache setImage:placeholderImage forKey:key];
    }
    return placeholderImage;
}

+ (UIImage *)live_placeholderImageBySize:(CGSize)size
{
    NSString *key = [NSString stringWithFormat:@"live_%@_%@", PlaceholderImageName, [NSValue valueWithCGSize:size]].md5String;
    YYImageCache *imageCache = [YYImageCache sharedCache];
    UIImage *placeholderImage = [imageCache getImageForKey:key];
    if (placeholderImage == nil) {
        placeholderImage = [self _placeholderImageBySize:size];
        placeholderImage = [placeholderImage imageByRoundCornerRadius:kCoverCornerRadius borderWidth:2.0 borderColor:[UIColor colorWithWhite:215 / 255.0 alpha:1.0]];
        [imageCache setImage:placeholderImage forKey:key];
    }
    return placeholderImage;
}

+ (UIImage *)banner_placeholderImageBySize:(CGSize)size
{
    NSString *key = [NSString stringWithFormat:@"banner_%@_%@", PlaceholderImageName, [NSValue valueWithCGSize:size]].md5String;
    YYImageCache *imageCache = [YYImageCache sharedCache];
    UIImage *placeholderImage = [imageCache getImageForKey:key];
    if (placeholderImage == nil) {
        placeholderImage = [self _placeholderImageBySize:size];
        [imageCache setImage:placeholderImage forKey:key];
    }
    return placeholderImage;
}

+ (UIImage *)transformImage:(UIImage *)originImage size:(CGSize)size cornerRadius:(CGFloat)radius style:(DdImageStyle)style
{
    UIImage *transformImage = [originImage imageByResizeToSize:CGSizeMake(size.width * kScreenScale, size.height * kScreenScale)];
    CGRect rect = CGRectMake(0, 0, transformImage.size.width, transformImage.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, kScreenScale);
    [transformImage drawInRect:rect];
    UIImage *gradientImage = [self _gradientImageWithRect:rect style:style];
    [gradientImage drawInRect:rect blendMode:kCGBlendModeMultiply alpha:1.0];
    transformImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    transformImage = [transformImage imageByRoundCornerRadius:radius];
    return transformImage;
}

+ (UIImage *)_placeholderImageBySize:(CGSize)size
{
    UIImage *bgImage = [UIImage imageWithColor:[UIColor colorWithRed:245 / 255.0 green:246 / 255.0 blue:247 / 255.0 alpha:1.0] size:CGSizeMake(size.width * kScreenScale, size.height * kScreenScale)];
    UIImage *centerImage = [UIImage imageNamed:PlaceholderImageName];
    CGRect rect = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, kScreenScale);
    [bgImage drawInRect:rect];
    [centerImage drawInRect:CGRectMake((rect.size.width - centerImage.size.width * kScreenScale) / 2, (rect.size.height - centerImage.size.height * kScreenScale) / 2, centerImage.size.width * kScreenScale, centerImage.size.height * kScreenScale)];
    
    UIImage *placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return placeholderImage;
}

+ (UIImage *)_gradientImageWithRect:(CGRect)rect style:(DdImageStyle)style {
    UIColor *inputColor0;
    UIColor *inputColor1;
    if (style == DdImageDarkGradient) {
        inputColor0 = [UIColor colorWithWhite:66 / 255.0 alpha:0.7];
        inputColor1 = [UIColor colorWithWhite:238 / 255.0 alpha:0.7];
    }else {
        return nil;
    }
    
    CIFilter *ciFilter = [CIFilter filterWithName:@"CILinearGradient"];
    CIVector *vector0 = [CIVector vectorWithX:rect.size.width * 0.5 Y:0];
    CIVector *vector1 = [CIVector vectorWithX:rect.size.width * 0.5 Y:rect.size.height * (1 - 0.5)];
    [ciFilter setValue:vector0 forKey:@"inputPoint0"];
    [ciFilter setValue:vector1 forKey:@"inputPoint1"];
    
    [ciFilter setValue:[CIColor colorWithCGColor:inputColor0.CGColor] forKey:@"inputColor0"];
    [ciFilter setValue:[CIColor colorWithCGColor:inputColor1.CGColor] forKey:@"inputColor1"];
    
    CIImage *ciImage = ciFilter.outputImage;
    CIContext *con = [CIContext contextWithOptions:nil];
    CGImageRef resultCGImage = [con createCGImage:ciImage
                                         fromRect:rect];
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
    CGImageRelease(resultCGImage);
    
    return resultUIImage;
}

@end
