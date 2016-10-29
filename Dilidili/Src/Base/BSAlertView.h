//
//  BSAlertView.h
//  CloudBase
//
//  Created by iMac on 2016/9/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 警告视图
 */
@interface BSAlertView : NSObject

/**
 填充颜色
 */
@property (nullable, nonatomic, strong) UIColor *tintColor;

/**
 构造方法

 @param title                      标题
 @param message                    信息
 @param cancelButtonTitle          取消按钮标题
 @param otherButtonTitles          其他按钮标题数组
 @param onButtonTouchUpInsideBlock 点击事件响应Block

 @return 警告视图实例
 */
- (nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nonnull NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles onButtonTouchUpInside:(nullable void (^)(BSAlertView * _Nonnull alertView, NSInteger buttonIndex))onButtonTouchUpInsideBlock;

- (nullable instancetype)init NS_UNAVAILABLE;

/**
 展示
 */
- (void)show;

@end
