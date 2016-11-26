//
//  BangumiGirdCell.h
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 番剧网格单元格
 */
@interface BangumiGirdCell : UICollectionViewCell

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 在线观看标签 */
@property (nonatomic, weak) UILabel *onlineLabel;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 索引标签 */
@property (nonatomic, weak) UILabel *indexLabel;

@end
