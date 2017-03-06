//
//  DdBasedViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 视图模型基类
 */
@interface DdBasedViewModel : NSObject

/**
 标题
 */
@property (nonatomic,copy) NSString *title;
/**
 视图控制器类名
 */
@property (nonatomic, copy) NSString *className;
/**
 链接
 */
@property(nonatomic, copy) NSURL *URL;
/**
 参数
 */
@property (nonatomic, copy) NSDictionary *params;

/**
 默认构造方法

 @param className 视图控制器类名
 @param params 参数
 @return 视图模型实例
 */
- (instancetype)initWithClassName:(NSString *)className params:(NSDictionary *)params;

@end
