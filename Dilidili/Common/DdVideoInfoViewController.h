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

/** 视频视图模型 */
@property (nonatomic, strong) DdVideoViewModel *videoViewModel;

@end
