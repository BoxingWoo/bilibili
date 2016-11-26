//
//  RecommendSectionHeader.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLoopScrollView.h"

/**
 推荐节头
 */
@interface RecommendSectionHeader : UICollectionReusableView

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *arrowImageView;
@property (nonatomic, weak) UIButton *moreBtn;

@end

/**
 推荐横幅广告节头
 */
@interface RecommendBannerSectionHeader : RecommendSectionHeader

@property (nonatomic, weak) BSLoopScrollView *loopScrollView;

@end
