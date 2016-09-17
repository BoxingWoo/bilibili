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

#pragma mark 获取视频播放链接
+ (RACCommand *)requestVideoPathByAid:(NSString *)aid
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSDictionary *parameters = @{@"aid":aid, @"page":@1};
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            manager.logMode = RequestLogDictionary;
            [manager GET:DdVideoPathURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if ([responseObject[@"src"] isNotBlank]) {
                    [subscriber sendNext:responseObject[@"src"]];
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

#pragma mark 获取视频信息链接
+ (RACCommand *)requestVideoInfoByAid:(NSString *)aid from:(NSString *)from
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            //http://app.bilibili.com/x/v2/view?actionKey=appkey&aid=6206361&appkey=27eb53fc9058f8c3&build=3710&device=phone&from=6&mobi_app=iphone&platform=ios&sign=ef348e588eea0d3a1bb336450abd9d57&ts=1473735123
            
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"aid"] = @"6206361";
            parameters[@"build"] = [AppInfo build];
            parameters[@"device"] = [AppInfo device];
            parameters[@"from"] = @"6";
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"ts"] = @(1473735123);
            parameters[@"sign"] = @"ef348e588eea0d3a1bb336450abd9d57";
            

//            parameters[@"actionKey"] = [AppInfo actionKey];
//            parameters[@"appkey"] = [AppInfo appkey];
//            parameters[@"aid"] = aid;
//            parameters[@"build"] = [AppInfo build];
//            parameters[@"device"] = [AppInfo device];
//            parameters[@"from"] = from;
//            parameters[@"mobi_app"] = [AppInfo mobi_app];
//            parameters[@"platform"] = [AppInfo platform];
//            NSInteger ts = [AppInfo ts];
//            parameters[@"sign"] = [AppInfo signParameters:parameters byTimeStamp:ts];
//            parameters[@"ts"] = @(ts);
            
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:DdVideoInfoURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    DdVideoModel *model = [DdVideoModel modelWithDictionary:responseObject[kResponseDataKey]];
                    [subscriber sendNext:model];
                }else {
                    [subscriber sendError:error];
                }

                [subscriber sendCompleted];
            }];
            return nil;
        }];
        return singal;
    }];
}

@end
