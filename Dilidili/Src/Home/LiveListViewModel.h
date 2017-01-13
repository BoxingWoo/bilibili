//
//  LiveListViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/11.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveListModel.h"
#import "LiveBannerModel.h"
#import "LiveHeaderView.h"
#import "LiveFooterView.h"
#import "LiveSectionHeader.h"
#import "LiveCell.h"

/**
 直播列表视图模型
 */
@interface LiveListViewModel : NSObject

/**
 直播列表模型
 */
@property (nonatomic, strong) LiveListModel *model;
/**
 是否是推荐直播
 */
@property (nonatomic, assign) BOOL isRecommended;

/**
 构造方法
 
 @param model 直播列表模型
 
 @return 直播视图模型实例
 */
- (instancetype)initWithModel:(LiveListModel *)model;

/**
 刷新直播列表数据
 
 @return RACCommand instance
 */
- (RACCommand *)refreshLiveData;

@end
