//
//  LiveListViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/11.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "LiveListViewModel.h"
#import "DdHTTPSessionManager.h"

@implementation LiveListViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(LiveListModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark 刷新直播列表数据
- (RACCommand *)refreshLiveData
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *url;
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            if (self.isRecommended) {
                url = DdLiveRecommendRefreshURL;
                parameters[@"sign"] = @"39e3b557397f1026ddb239731c213004";
                parameters[@"ts"] = @(1475576802);
            }else {
                url = DdLiveRefreshURL;
                parameters[@"area"] = self.model.partition.area;
                parameters[@"sign"] = [AppInfo sign];
                parameters[@"ts"] = @([AppInfo ts]);
            }
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"build"] = [AppInfo build];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"platform"] = [AppInfo platform];
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:url parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    if (self.isRecommended) {
                        NSDictionary *dict = responseObject[kResponseDataKey];
                        self.model.lives = [NSArray modelArrayWithClass:[LiveModel class] json:dict[@"lives"]];
                        self.model.banner_data = [NSArray modelArrayWithClass:[LiveModel class] json:dict[@"banner_data"]];
                        self.model.partition.count = [[dict[@"partition"] objectForKey:@"count"] unsignedIntegerValue];
                    }else {
                        self.model.lives = [NSArray modelArrayWithClass:[LiveModel class] json:responseObject[kResponseDataKey]];
                    }
                    [subscriber sendNext:nil];
                }else {
                    [subscriber sendError:error];
                }
                [subscriber sendCompleted];
            }];
            return nil;
            
        }];
        return signal;
    }];
}

@end
