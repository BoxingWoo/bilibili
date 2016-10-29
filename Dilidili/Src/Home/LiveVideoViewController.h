//
//  LiveVideoViewController.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 直播视频视图控制器
 */
@interface LiveVideoViewController : UIViewController

/**
 房间ID
 */
@property (nonatomic, assign) NSInteger room_id;
/**
 播放地址
 */
@property (nonatomic, copy) NSString *playurl;

@end
