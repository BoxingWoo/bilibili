//
//  LiveRecommendView.h
//  Dilidili
//
//  Created by iMac on 2016/10/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 直播推荐视图
 */
@interface LiveRecommendView : UIControl

/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverImageView;
/** 头像视图 */
@property (nonatomic, weak) YYAnimatedImageView *faceImageView;
/** 姓名标签 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 标题标签 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 在线人数标签 */
@property (nonatomic, weak) UILabel *onlineLabel;

@end
