//
//  DdProgressHUD.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

/**
 自定义进度指示器
 */
@interface DdProgressHUD : NSObject

+ (void)show;

+ (void)showWithStatus:(NSString*)status;

+ (void)showInfoWithStatus:(NSString*)status;

+ (void)showSuccessWithStatus:(NSString*)status;

+ (void)showErrorWithStatus:(NSString*)status;

+ (void)showImage:(UIImage*)image status:(NSString*)status;

+ (void)dismiss;

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion;

@end
