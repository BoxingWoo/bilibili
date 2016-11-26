//
//  RecommendSectionFooter.h
//  Dilidili
//
//  Created by iMac on 16/8/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLoopScrollView.h"

/**
 推荐节尾
 */
@interface RecommendSectionFooter : UICollectionReusableView

/** 循环滚动视图 */
@property (nonatomic, weak) BSLoopScrollView *loopScrollView;

@end
