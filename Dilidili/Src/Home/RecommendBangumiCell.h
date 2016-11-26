//
//  RecommendBangumiCell.h
//  Dilidili
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 推荐番剧标签
 */
@interface RecommendBangumiCell : UICollectionViewCell

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 索引标签 */
@property (nonatomic, weak) UILabel *indexLabel;

@end
