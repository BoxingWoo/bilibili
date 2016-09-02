//
//  DdHTTPSessionManager.h
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 *  @brief 请求响应状态
 */
typedef NS_ENUM(NSInteger, ResponseCode) {
    /**
     *  成功
     */
    ResponseCodeSuccess = 0,
};


/**
 *  @brief 网络请求数据缓存策略
 */
typedef NS_ENUM(NSUInteger, RequestCachePolicy) {
    /**
     *  默认缓存策略，不读取且不写入缓存数据
     */
    RequestUseDefaultCachePolicy = 0,
    /**
     *  请求网络数据并返回，不读取缓存数据，但会写入
     */
    RequestReloadIgnoringCacheData = 1,
    /**
     *  先返回缓存数据，然后请求网络数据并返回
     */
    RequestReturnCacheDataAndLoad = 2,
    /**
     *  如果缓存数据存在，只返回缓存数据且不请求网络数据
     */
    RequestReturnCacheDataDontLoad = 3,
    /**
     *  只返回缓存数据，然后请求网络数据并缓存，但不返回
     */
    RequestReturnCacheDataThenCacheLoadData = 4,
};


/**
 *  @brief 网络请求调试打印模式
 */
typedef NS_ENUM(NSInteger, RequestLogMode) {
    /**
     *  打印错误信息
     */
    RequestLogError = 0,
    /**
     *  打印请求URL和错误信息
     */
    RequestLogURL = 1,
    /**
     *  打印JSON字符串、请求URL和错误信息
     */
    RequestLogString = 2,
    /**
     *  打印JSON字典、请求URL和错误信息
     */
    RequestLogDictionary = 3
};

extern NSString *const DdRequestErrorDomain;


/**
 *  @brief dilidili网络请求类，基于AFHTTPSessionManager的二次封装
 */
@interface DdHTTPSessionManager : AFHTTPSessionManager

/**
 *  @brief 网络请求缓存策略
 */
@property (nonatomic, assign) RequestCachePolicy cachePolicy;

/**
 *  @brief 网络请求调试打印模式
 */
@property (nonatomic, assign) RequestLogMode logMode;


/**
 *  @brief GET请求
 *
 *  @param URLString          接口
 *  @param parameters         参数
 *  @param complectionHandler 回调Block(响应代码，数据对象，错误)
 *
 *  @return 网络请求任务
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters complection:(void (^)(ResponseCode code, NSDictionary *responseObject, NSError *error))complectionHandler;

/**
 *  @brief POST请求
 *
 *  @param URLString          接口
 *  @param parameters         参数
 *  @param complectionHandler 回调Block(响应代码，数据对象，错误)
 *
 *  @return 网络请求任务
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters complection:(void (^)(ResponseCode code, NSDictionary *responseObject, NSError *error))complectionHandler;

@end
