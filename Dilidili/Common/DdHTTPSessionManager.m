//
//  DdHTTPSessionManager.m
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdHTTPSessionManager.h"

/**
 *  @brief dilidili硬盘缓存
 */
@interface YYDiskCache (Dilidili)

/**
 *  @brief 单例方法
 *
 *  @return 单例对象
 */
+ (instancetype)shareInstance;

@end

@implementation YYDiskCache (Dilidili)

+ (instancetype)shareInstance
{
    static YYDiskCache *diskCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"BoxingWoo.Dilidili.RequestCachePath"];
        diskCache = [[self alloc] initWithPath:path inlineThreshold:0];
        diskCache.ageLimit = 86400;
    });
    return diskCache;
}

@end



@implementation DdHTTPSessionManager

NSString *const DdRequestErrorDomain = @"BoxingWoo.Dilidili.RequestErrorDomain";

#pragma mark 类构造方法
+ (instancetype)manager
{
    return [[self alloc] init];
}

#pragma mark 构造方法
- (instancetype)init
{
    return [self initWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

#pragma mark 默认构造方法
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        self.requestSerializer.timeoutInterval = 30.0;  //30s超时
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.cachePolicy = RequestUseDefaultCachePolicy;
        self.logMode = RequestLogURL;
    }
    return self;
}

#pragma mark GET请求
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters complection:(void (^)(ResponseCode, NSDictionary *, NSError *))complectionHandler
{
    NSMutableString *absoluteString = [[NSMutableString alloc] initWithString:URLString];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [absoluteString appendString:@"?"];
        for (id key in parameters) {
            if ([key isEqualToString:@"ts"]) {
                continue;
            }
            [absoluteString appendFormat:@"%@=%@&", key, parameters[key]];
        }
        [absoluteString deleteCharactersInRange:NSMakeRange(absoluteString.length - 1, 1)];
    }
    
    if (self.logMode != RequestLogError) {
        DDLogInfo(@"%@", absoluteString);
    }
    
    id cacheDataObject = nil;
    if (self.cachePolicy != RequestUseDefaultCachePolicy) {
        if (self.cachePolicy != RequestReloadIgnoringCacheData || !self.reachabilityManager.reachable) {
            //加载本地缓存数据
            YYDiskCache *dickCache = [YYDiskCache shareInstance];
            cacheDataObject = [dickCache objectForKey:absoluteString.md5String];
            if (cacheDataObject) {
                if (complectionHandler) {
                    complectionHandler(ResponseCodeSuccess, cacheDataObject, nil);
                }
                if (self.cachePolicy == RequestReturnCacheDataDontLoad) {
                    return nil;
                }
            }
        }
    }
    
    @weakify(self);
    return [self GET:URLString parameters:parameters progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        @strongify(self);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        switch (self.logMode) {
            case RequestLogString:
                DDLogDebug(@"%@", responseString);
                break;
            case RequestLogDictionary:
                DDLogDebug(@"%@", responseDict);
                break;
            default:
                break;
        }
        
        ResponseCode code = -1;
        NSError *error = nil;
        code = [responseDict[kResponseCodeKey] integerValue];
        if (code != 0) {
            error = [NSError errorWithDomain:DdRequestErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:responseDict[kResponseMessageKey]}];
        }
        
        if (self.cachePolicy != RequestUseDefaultCachePolicy) {
            //缓存网络数据到本地
            YYDiskCache *diskCache = [YYDiskCache shareInstance];
            [diskCache setObject:responseDict forKey:absoluteString.md5String];
        }
        
        if (self.cachePolicy != RequestReturnCacheDataThenCacheLoadData || !cacheDataObject) {
            if (complectionHandler) {
                complectionHandler(code, responseDict, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        @strongify(self);
        DDLogError(@"%@", error);
        error = [NSError errorWithDomain:DdRequestErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:kServiceErrorText}];
        if (complectionHandler && self.cachePolicy != RequestReturnCacheDataThenCacheLoadData) {
            complectionHandler(-1, nil, error);
        }
        
    }];
}

#pragma mark POST请求
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters complection:(void (^)(ResponseCode, NSDictionary *, NSError *))complectionHandler
{
    NSMutableString *absoluteString = [[NSMutableString alloc] initWithString:URLString];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [absoluteString appendString:@"?"];
        for (id key in parameters) {
            if ([key isEqualToString:@"ts"]) {
                continue;
            }
            [absoluteString appendFormat:@"%@=%@&", key, parameters[key]];
        }
        [absoluteString deleteCharactersInRange:NSMakeRange(absoluteString.length - 1, 1)];
    }
    
    if (self.logMode != RequestLogError) {
        DDLogInfo(@"%@", absoluteString);
    }
    
    id cacheDataObject = nil;
    if (self.cachePolicy != RequestUseDefaultCachePolicy) {
        if (self.cachePolicy != RequestReloadIgnoringCacheData || !self.reachabilityManager.reachable) {
            //加载本地缓存数据
            YYDiskCache *dickCache = [YYDiskCache shareInstance];
            cacheDataObject = [dickCache objectForKey:absoluteString.md5String];
            if (cacheDataObject) {
                if (complectionHandler) {
                    complectionHandler(ResponseCodeSuccess, cacheDataObject, nil);
                }
                if (self.cachePolicy == RequestReturnCacheDataDontLoad) {
                    return nil;
                }
            }
        }
    }
    
    @weakify(self);
    return [self POST:URLString parameters:parameters progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        @strongify(self);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        switch (self.logMode) {
            case RequestLogString:
                DDLogDebug(@"%@", responseString);
                break;
            case RequestLogDictionary:
                DDLogDebug(@"%@", responseDict);
                break;
            default:
                break;
        }
        
        ResponseCode code = -1;
        NSError *error = nil;
        code = [responseDict[kResponseCodeKey] integerValue];
        if (code != 0) {
            error = [NSError errorWithDomain:DdRequestErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:responseDict[kResponseMessageKey]}];
        }
        
        if (self.cachePolicy != RequestUseDefaultCachePolicy) {
            //缓存网络数据到本地
            YYDiskCache *diskCache = [YYDiskCache shareInstance];
            [diskCache setObject:responseDict forKey:absoluteString.md5String];
        }
        
        if (self.cachePolicy != RequestReturnCacheDataThenCacheLoadData || !cacheDataObject) {
            if (complectionHandler) {
                complectionHandler(code, responseDict, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        @strongify(self);
        DDLogError(@"%@", error);
        error = [NSError errorWithDomain:DdRequestErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:kServiceErrorText}];
        if (complectionHandler && self.cachePolicy != RequestReturnCacheDataThenCacheLoadData) {
            complectionHandler(-1, nil, error);
        }
        
    }];
}

@end
