//
//  DdVideoReplyViewController.h
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DdReplyViewModel.h"

/**
 *  @brief 视频评论视图控制器
 */
@interface DdVideoReplyViewController : UIViewController

/** 页面信息 */
@property (nonatomic, copy) NSDictionary *page;
/** 标识 */
@property (nonatomic, assign) NSString *oid;
/** 页数 */
@property (nonatomic, assign) NSUInteger pageNum;

/**
 *  @brief 请求数据
 */
- (RACSignal *)requestData;

@end
