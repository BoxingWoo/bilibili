//
//  LiveFlowLayout.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiveViewModel;

extern NSString *const LiveCollectionElementKindHeaderView;
extern NSString *const LiveCollectionElementKindFooterView;

/**
 直播列表流式布局
 */
@interface LiveFlowLayout : UICollectionViewFlowLayout

/**
 直播视图模型数组
 */
@property (nonatomic, copy) NSArray <LiveViewModel *> *viewModels;

@end
