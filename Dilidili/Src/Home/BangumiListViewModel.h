//
//  BangumiListViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/11.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BangumiListModel.h"
#import "BangumiBannerModel.h"
#import "BangumiHeaderView.h"
#import "BangumiSectionHeader.h"
#import "BangumiSectionFooter.h"
#import "BangumiGirdCell.h"
#import "BangumiListCell.h"

/**
 番剧列表视图模型
 */
@interface BangumiListViewModel : NSObject

/**
 番剧列表模型
 */
@property (nonatomic, strong) BangumiListModel *model;
/**
 单元格大小
 */
@property (nonatomic, assign) CGSize cellSize;

/**
 构造方法
 
 @param model 番剧列表模型
 
 @return 番剧视图模型实例
 */
- (instancetype)initWithModel:(BangumiListModel *)model;

@end
