//
//  BangumiListViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/11.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "BangumiListViewModel.h"

@implementation BangumiListViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(BangumiListModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

@end
