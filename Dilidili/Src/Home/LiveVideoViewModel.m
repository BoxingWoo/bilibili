//
//  LiveVideoViewModel.m
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveVideoViewModel.h"
#import "DdHTTPSessionManager.h"

@implementation LiveVideoViewModel

- (void)setURL:(NSURL *)URL
{
    [super setURL:URL];
    if ([URL.absoluteString isNotBlank]) {
        _room_id = [[URL.path stringByReplacingOccurrencesOfString:@"/" withString:@""] integerValue];
    }
}

#pragma mark 请求直播信息
- (RACCommand *)requestLiveInfo
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appKey"] = [AppInfo appkey];
            parameters[@"build"] = [AppInfo build];
            parameters[@"buvid"] = [AppInfo buvid];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"room_id"] = @(self.room_id);
            parameters[@"scale"] = @(kScreenScale);
            parameters[@"sign"] = [AppInfo sign];
            parameters[@"ts"] = @([AppInfo ts]);
            
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:DdLiveInfoURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    self.model = [LiveInfoModel modelWithJSON:responseObject[kResponseDataKey]];
                    [subscriber sendNext:nil];
                }else {
                    [subscriber sendError:error];
                }
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

@end
