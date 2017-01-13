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

- (void)setURL:(NSURL *)URL
{
    [super setURL:URL];
    _aid = [self.URL.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
}

#pragma mark 获取视频播放链接
- (RACCommand *)requestVideoURL
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"callback"] = @"jQuery17209494781185433222_1479709396179";
            parameters[@"page"] = @1;
            parameters[@"platform"] = @"html5";
            parameters[@"quality"] = @1;
            parameters[@"vtype"] = @"mp4";
            parameters[@"type"] = @"jsonp";
            parameters[@"token"] = @"d41d8cd98f00b204e9800998ecf8427e";
            parameters[@"_"] = @([AppInfo ts]);
            parameters[@"aid"] = self.aid;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:DdVideoPathURL parameters:parameters progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSArray *array = [responseString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
                NSString *string = array[1];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                
                if ([dict[kResponseCodeKey] integerValue] == 0) {
                    self.cid = dict[@"cid"];
                    NSDictionary *urlDict = [dict[@"durl"] firstObject];
                    self.contentURL = [NSURL URLWithString:urlDict[@"url"]];
                    [subscriber sendNext:nil];
                }else {
                    [subscriber sendError:nil];
                }
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
