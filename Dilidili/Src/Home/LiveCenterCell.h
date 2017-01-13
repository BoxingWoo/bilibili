//
//  LiveCenterCell.h
//  Dilidili
//
//  Created by iMac on 2016/10/28.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCentralButton.h"

/**
 直播中心单元格
 */
@interface LiveCenterCell : UITableViewCell

/**
 功能按钮数组
 */
@property (nonatomic, copy) NSArray *buttons;
/**
 按钮事件响应
 */
@property (nonatomic, strong) RACSubject *actionSubject;

@end
