//
//  RecommendBangumiFooter.h
//  Dilidili
//
//  Created by iMac on 16/8/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 推荐番剧节尾
 */
@interface RecommendBangumiFooter : UICollectionReusableView

/** 每日放送按钮 */
@property (nonatomic, weak) UIButton *timelineBtn;
/** 番剧索引按钮 */
@property (nonatomic, weak) UIButton *categoryBtn;

@end
