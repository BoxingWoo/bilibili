//
//  DdReplyListViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/10.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdReplyListViewModel.h"

@implementation DdReplyListViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(DdReplyModel *)model
{
    if (self = [super init]) {
        _model = model;
        NSMutableArray *replies = [NSMutableArray array];
        for (DdReplyModel *replyModel in model.replies) {
            DdReplyListViewModel *viewModel = [[DdReplyListViewModel alloc] initWithModel:replyModel];
            [replies addObject:viewModel];
        }
        _replies = replies;
    }
    return self;
}

@end
