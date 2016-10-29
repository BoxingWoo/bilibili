//
//  DdProgressHUD.m
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdProgressHUD.h"

@implementation DdProgressHUD

+ (void)initialize
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:3.0];
}

+ (void)show
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD show];
}

+ (void)showWithStatus:(NSString *)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showInfoWithStatus:(NSString*)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showSuccessWithStatus:(NSString *)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)showImage:(UIImage *)image status:(NSString *)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showImage:image status:status];
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion
{
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

@end
