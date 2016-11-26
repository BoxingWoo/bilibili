//
//  RecommendLiveCell.h
//  Dilidili
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 推荐直播单元格
 */
@interface RecommendLiveCell : UICollectionViewCell

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 头像视图 */
@property (nonatomic, weak) YYAnimatedImageView *faceImageView;
/** 姓名标签 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 在线人数标签 */
@property (nonatomic, weak) UILabel *onlineLabel;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 刷新按钮 */
@property (nonatomic, weak) UIButton *refreshBtn;

@end
