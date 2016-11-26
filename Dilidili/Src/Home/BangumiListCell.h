//
//  BangumiListCell.h
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 番剧列表单元格
 */
@interface BangumiListCell : UICollectionViewCell

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 标题标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 描述标签 */
@property (nonatomic, weak) UILabel *descLabel;

@end
