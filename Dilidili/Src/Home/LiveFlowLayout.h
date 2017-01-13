//
//  LiveFlowLayout.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiveListViewModel;

extern NSString *const kLiveCollectionElementKindHeaderView;  //直播集合视图头部视图标识
extern NSString *const kLiveCollectionElementKindFooterView;  //直播集合视图尾部视图标识

/**
 直播列表流式布局
 */
@interface LiveFlowLayout : UICollectionViewFlowLayout

/**
 直播视图模型数组
 */
@property (nonatomic, copy) NSArray <LiveListViewModel *> *viewModels;

@end
