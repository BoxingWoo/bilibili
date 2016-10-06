//
//  DdVideoViewModel.m
//  Dilidili
//
//  Created by iMac on 16/9/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoViewModel.h"
#import "DdHTTPSessionManager.h"

@implementation DdVideoViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(DdVideoModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark 获取视频信息链接
+ (RACCommand *)requestVideoInfoByAid:(NSString *)aid from:(NSString *)from
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//            parameters[@"actionKey"] = [AppInfo actionKey];
//            parameters[@"appkey"] = [AppInfo appkey];
//            parameters[@"aid"] = aid;
//            parameters[@"build"] = [AppInfo build];
//            parameters[@"device"] = [AppInfo device];
//            parameters[@"from"] = from;
//            parameters[@"mobi_app"] = [AppInfo mobi_app];
//            parameters[@"platform"] = [AppInfo platform];
//            NSInteger ts = [AppInfo ts];
//            parameters[@"sign"] = [AppInfo sign];
//            parameters[@"ts"] = @(ts);
//            
//            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
//            [manager GET:DdVideoInfoURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
//                if (code == 0) {
//                    DdVideoModel *model = [DdVideoModel modelWithDictionary:responseObject[kResponseDataKey]];
//                    [subscriber sendNext:model];
//                }else {
//                    [subscriber sendError:error];
//                }
//
//                [subscriber sendCompleted];
//            }];
            
            [subscriber sendError:nil];
            [subscriber sendCompleted];
            return nil;
        }];
        return singal;
    }];
}

#pragma mark 获取视频播放链接
+ (RACCommand *)requestVideoURLByAid:(NSString *)aid
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"callback"] = @"jQuery172024158705611356257_1475488753004";
            parameters[@"page"] = @1;
            parameters[@"platform"] = @"html5";
            parameters[@"quality"] = @1;
            parameters[@"vtype"] = @"mp4";
            parameters[@"type"] = @"jsonp";
            parameters[@"_"] = @([AppInfo ts]);
            parameters[@"aid"] = aid;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:DdVideoPathURL parameters:parameters progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSArray *array = [responseString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
                NSString *string = array[1];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                [subscriber sendNext:dict];
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        return signal;
    }];
}

@end
