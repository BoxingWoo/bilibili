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

#pragma mark 构造方法
- (instancetype)initWithModel:(LiveInfoModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark 请求直播信息
+ (RACCommand *)requestLiveInfoByRoomID:(NSInteger)room_id
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appKey"] = [AppInfo appkey];
            parameters[@"build"] = [AppInfo build];
            parameters[@"buvid"] = [AppInfo buvid];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"room_id"] = @(room_id);
            parameters[@"scale"] = @(kScreenScale);
            parameters[@"sign"] = [AppInfo sign];
            parameters[@"ts"] = @([AppInfo ts]);
            
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:DdLiveInfoURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    LiveInfoModel *model = [LiveInfoModel modelWithJSON:responseObject[kResponseDataKey]];
                    [subscriber sendNext:model];
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
