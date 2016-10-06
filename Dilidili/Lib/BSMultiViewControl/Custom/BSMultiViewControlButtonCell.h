//
//  BSMultiViewControlButtonCell.h
//
//  Created by BoxingWoo on 15/8/15.
//  Copyright (c) 2015年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @brief 竖向列表式标题视图
 */
@interface BSMultiViewControlButtonCell : UITableViewCell

/** 标题按钮 */
@property (nonatomic, weak) UIButton *titleButton;

/** 右分割线 */
@property (nonatomic, weak) CALayer *rightSeparatedLine;

/** 底分割线 */
@property (nonatomic, weak) CALayer *bottomSeparatedLine;

/** 构造方法 */
- (instancetype)initWithTitleButton:(UIButton *)titleButton;

@end
