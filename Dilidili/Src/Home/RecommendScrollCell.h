//
//  RecommendScrollCell.h
//  Dilidili
//
//  Created by iMac on 16/8/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 推荐滚动内容视图
 */
@interface RecommendScrollContentView : UIControl

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 索引路径 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

/**
 推荐滚动单元格
 */
@interface RecommendScrollCell : UICollectionViewCell

/** 滚动视图 */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 内容视图数组 */
@property (nonatomic, copy) NSArray *contentViews;

/**
 复用内容视图

 @param index 索引
 @return 推荐滚动内容视图
 */
- (RecommendScrollContentView *)dequeueReusableContentViewforIndex:(NSUInteger)index;

@end
