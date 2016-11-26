//
//  CategoryCell.h
//  Dilidili
//
//  Created by iMac on 2016/11/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 分区单元格
 */
@interface CategoryCell : UICollectionViewCell

/** 图标视图 */
@property (nonatomic, weak) UIImageView *iconImageView;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;

@end
