//
//  RecommendCell.h
//  Dilidili
//
//  Created by iMac on 16/8/27.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 推荐列表单元格
 */
@interface RecommendCell : UICollectionViewCell

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 播放次数 */
@property (nonatomic, weak) UIButton *playCount;
/** 弹幕数 */
@property (nonatomic, weak) UIButton *danmakuCount;

@end

/**
 推荐列表刷新单元格
 */
@interface RecommendRefreshCell : RecommendCell

/** 刷新按钮 */
@property (nonatomic, weak) UIButton *refreshBtn;

@end
