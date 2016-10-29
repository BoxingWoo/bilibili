//
//  BSActionSheet.h
//  Dilidili
//
//  Created by iMac on 2016/10/26.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 动作表单
 */
@interface BSActionSheet : NSObject

/**
 填充颜色
 */
@property (nullable, nonatomic, strong) UIColor *tintColor;

/**
 构造方法

 @param title                      标题
 @param cancelButtonTitle          取消按钮标题
 @param destructiveButtonTitle     破坏性按钮标题
 @param otherButtonTitles          其它按钮标题数组
 @param onButtonTouchUpInsideBlock 点击事件响应Block

 @return 动作表单实例
 */
- (nullable instancetype)initWithTitle:(nullable NSString *)title cancelButtonTitle:(nullable NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSArray<NSString *> *)otherButtonTitles onButtonTouchUpInside:(nullable void (^)(BSActionSheet * _Nonnull actionSheet, NSInteger buttonIndex))onButtonTouchUpInsideBlock;

- (nullable instancetype)init NS_UNAVAILABLE;

/**
 展示
 */
- (void)show;

@end
