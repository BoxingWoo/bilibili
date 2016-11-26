//
//  BangumiSectionHeader.h
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 番剧节头
 */
@interface BangumiSectionHeader : UICollectionReusableView

/** 图标视图 */
@property (nonatomic, weak) UIImageView *iconImageView;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 更多按钮 */
@property (nonatomic, weak) UIButton *moreBtn;
/** 箭头视图 */
@property (nonatomic, weak) UIImageView *arrowImageView;

@end
