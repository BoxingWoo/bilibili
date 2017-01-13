//
//  DdDanmakuViewModel.m
//  Dilidili
//
//  Created by iMac on 2016/9/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdDanmakuViewModel.h"
#import "DdHTTPSessionManager.h"

#pragma mark - 弹幕解析器

@interface DdDanmakuParser : NSObject <NSXMLParserDelegate>
{
    NSXMLParser *_parser;
}

/**
 构造方法

 @param XMLData XML数据

 @return 弹幕解析器实例
 */
- (instancetype)initWithXMLData:(NSData *)XMLData;

/**
 解析XML数据

 @param completionHandler 回调Block(danmakus:弹幕视图模型模型数组, maxlimit:弹幕数量最大限制, error:错误)
 */
- (void)parseWithCompletionHandler:(void (^)(NSArray <DdDanmakuListViewModel *> *danmakus, NSUInteger maxlimit, NSError *error))completionHandler;

@end

@implementation DdDanmakuParser
{
    NSUInteger _maxlimit;
    NSMutableArray *_parseObjects;
    NSMutableString *_tempStr;
    DdDanmakuModel *_tempModel;
}

#pragma mark 构造方法
- (instancetype)initWithXMLData:(NSData *)XMLData
{
    if (self = [super init]) {
        _parser = [[NSXMLParser alloc] initWithData:XMLData];
        _parser.delegate = self;
        _maxlimit = 0;
    }
    return self;
}

#pragma mark 解析XML数据
- (void)parseWithCompletionHandler:(void (^)(NSArray<DdDanmakuListViewModel *> *, NSUInteger, NSError *))completionHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *danmakus = nil;
        NSUInteger maxlimit = 0;
        NSError *error = nil;
        BOOL result = [_parser parse];
        if (result) {
            danmakus = [_parseObjects copy];
            maxlimit = _maxlimit;
        }else {
            error = _parser.parserError;
            DDLogError(@"%@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(danmakus, maxlimit, error);
            }
        });
    });
}

#pragma mark NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _parseObjects = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"maxlimit"]) {
        _tempStr = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"d"]) {
        _tempStr = [[NSMutableString alloc] init];
        _tempModel = [[DdDanmakuModel alloc] init];
        NSString *p = attributeDict[@"p"];
        NSArray *attributes = [p componentsSeparatedByString:@","];
        _tempModel.danmuku_id = attributes.lastObject;
        _tempModel.delay = [attributes.firstObject doubleValue];
        _tempModel.style = [attributes[1] integerValue];
        _tempModel.ctime = [attributes[4] doubleValue];
        NSInteger fontSize = [attributes[2] doubleValue];
        switch (fontSize) {
            case DdDanmakuFontSizeNormal:
                _tempModel.fontSize = 17;
                break;
            case DdDanmakuFontSizeSmall:
                _tempModel.fontSize = 14;
                break;
            default:
                _tempModel.fontSize = 17;
                break;
        }
        _tempModel.textColorValue = [attributes[3] integerValue];
        CGFloat colorAlpha = [DdDanmakuUserDefaults sharedInstance].opacity;
        switch (_tempModel.textColorValue) {
            case DdDanmakuRed:
                _tempModel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:colorAlpha];
                break;
            case DdDanmakuBule:
                _tempModel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:colorAlpha];
                break;
            case DdDanmakuCyan:
                _tempModel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:colorAlpha];
                break;
            case DdDanmakuGreen:
                _tempModel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:colorAlpha];
                break;
            case DdDanmakuPurple:
                _tempModel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:colorAlpha];
                break;
            case DdDanmakuYellow:
                _tempModel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:colorAlpha];
                break;
            case DdDanmakuMagenta:
                _tempModel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:colorAlpha];
                break;
            case DdDanmakuWhite:
                _tempModel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:colorAlpha];
                break;
            default:
                _tempModel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:colorAlpha];
                break;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [_tempStr appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"maxlimit"]) {
        _maxlimit = [_tempStr unsignedIntegerValue];
    }else if ([elementName isEqualToString:@"d"]) {
        _tempModel.text = _tempStr;
        DdDanmakuListViewModel *viewModel = [[DdDanmakuListViewModel alloc] initWithModel:_tempModel];
        [_parseObjects addObject:viewModel];
    }
}

@end



#pragma mark - 弹幕视图模型

@implementation DdDanmakuViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _renderer = [[BarrageRenderer alloc] init];
        _renderer.canvasMargin = UIEdgeInsetsZero;
        _renderer.redisplay = NO;
        @weakify(self);
        [[[DdDanmakuUserDefaults sharedInstance] rac_valuesForKeyPath:@"speed" observer:self] subscribeNext:^(id x) {
            @strongify(self);
            self.renderer.speed = [x doubleValue] * 1 / 7.5;
        }];
    }
    return self;
}

#pragma mark 请求弹幕数据
- (RACCommand *)requestDanmakuData
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer.timeoutInterval = 30.0;
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSString *URLString = self.cid;
            DDLogInfo(@"%@", URLString);
            [manager GET:URLString parameters:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                DdDanmakuParser *parser = [[DdDanmakuParser alloc] initWithXMLData:responseObject];
                [parser parseWithCompletionHandler:^(NSArray<DdDanmakuListViewModel *> *danmakus, NSUInteger maxlimit, NSError *error) {
                    if (!error) {
                        self.danmakus = danmakus;
                        self.maxlimit = maxlimit;
                        [subscriber sendNext:nil];
                    }else {
                        [subscriber sendError:error];
                    }
                    [subscriber sendCompleted];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                error = [NSError errorWithDomain:DdRequestErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:kServiceErrorText}];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        self.danmakuSignal = signal;
        return signal;
    }];
}

@end
