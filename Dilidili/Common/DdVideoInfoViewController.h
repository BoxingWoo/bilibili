//
//  DdVideoInfoViewController.h
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DdVideoViewModel.h"

/**
 *  @brief 视频信息视图控制器
 */
@interface DdVideoInfoViewController : UIViewController

/** 标识 */
@property (nonatomic, copy) NSString *aid;
/** 类别 */
@property (nonatomic, copy) NSString *from;

/**
 *  @brief 请求数据
 */
- (RACSignal *)requestData;

@end
