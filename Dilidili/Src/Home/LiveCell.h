//
//  LiveCell.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 直播列表单元格
 */
@interface LiveCell : UICollectionViewCell

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 姓名标签 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 在线按钮 */
@property (nonatomic, weak) UIButton *onlineBtn;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;

@end

/**
 直播刷新单元格
 */
@interface LiveRefreshCell : LiveCell

/** 刷新按钮 */
@property (nonatomic, weak) UIButton *refreshBtn;

@end
