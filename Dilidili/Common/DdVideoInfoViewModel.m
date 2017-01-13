//
//  DdVideoInfoViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/10.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdVideoInfoViewModel.h"
#import "DdHTTPSessionManager.h"

@implementation DdVideoInfoViewModel

#pragma mark 获取视频信息链接
- (RACCommand *)requestVideoInfo
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//            
//            parameters[@"actionKey"] = [AppInfo actionKey];
//            parameters[@"appkey"] = [AppInfo appkey];
//            parameters[@"aid"] = self.aid;
//            parameters[@"build"] = [AppInfo build];
//            parameters[@"device"] = [AppInfo device];
//            parameters[@"from"] = self.from;
//            parameters[@"mobi_app"] = [AppInfo mobi_app];
//            parameters[@"platform"] = [AppInfo platform];
//            NSInteger ts = [AppInfo ts];
//            parameters[@"sign"] = [AppInfo sign];
//            parameters[@"ts"] = @(ts);
//            
//            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
//            [manager GET:DdVideoInfoURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
//                if (code == 0) {
//                    self.model = [DdVideoModel modelWithDictionary:responseObject[kResponseDataKey]];
//                        [subscriber sendNext:nil];
//                }else {
//                    [subscriber sendError:error];
//                }
//                    [subscriber sendCompleted];
//            }];
            
            [subscriber sendError:nil];
            [subscriber sendCompleted];
            return nil;
        }];

        self.infoSignal = signal;
        return signal;
    }];
}

@end
