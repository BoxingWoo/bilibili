//
//  LiveSectionHeader.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 直播节头
 */
@interface LiveSectionHeader : UICollectionReusableView

/** 图标视图 */
@property (nonatomic, weak) UIImageView *iconImageView;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 更多按钮 */
@property (nonatomic, weak) UIButton *moreBtn;

@end
