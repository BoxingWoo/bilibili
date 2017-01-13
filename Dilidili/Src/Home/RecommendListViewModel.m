//
//  RecommendListViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "RecommendListViewModel.h"
#import "DdHTTPSessionManager.h"
#import "DdImageManager.h"

@implementation RecommendListViewModel

- (instancetype)initWithModel:(RecommendListModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark 单元格大小
- (CGSize)cellSize
{
    if ([self.model.style isEqualToString:RecommendStyleSmall]) {
        return CGSizeMake(kScreenWidth, heightEx(90.0) + 42.0 + 4.0 * 2);
    }else {
        if ([self.model.type isEqualToString:RecommendTypeLive]) {
            return CGSizeMake(widthEx(146.0), heightEx(92.0) + 44.0);
        }else if ([self.model.type isEqualToString:RecommendTypeBangumi]) {
            return CGSizeMake(widthEx(146.0), heightEx(92.0) + 36.0);
        }else {
            return CGSizeMake(widthEx(146.0), heightEx(92.0) + 40.0);
        }
    }
}

#pragma mark 推荐列表头部视图高度
- (CGFloat)sectionHeaderHeight
{
    if (self.model.bannerTop.count > 0) {
        return heightEx(96.0) + 42.0;
    }else {
        return 34.0;
    }
}

#pragma mark 推荐列表尾部视图高度
- (CGFloat)sectionFooterHeight
{
    if ([self.model.type isEqualToString:RecommendTypeBangumi]) {
        return heightEx(42.0) + 6.0 + 12.0;
    }else {
        if (self.model.bannerBottom.count > 0) {
            return heightEx(96.0);
        }else {
            return 0.0;
        }
    }
}

#pragma mark LoopScrollViewDataSource

- (NSUInteger)numberOfItemsInLoopScrollView:(BSLoopScrollView *)loopScrollView
{
    if ([loopScrollView.superview isKindOfClass:[RecommendSectionHeader class]]) {
        return self.model.bannerTop.count;
    }else if ([loopScrollView.superview isKindOfClass:[RecommendSectionFooter class]]) {
        return self.model.bannerBottom.count;
    }
    return 0;
}

- (UIView *)loopScrollView:(BSLoopScrollView *)loopScrollView contentViewAtIndex:(NSUInteger)index
{
    BannerModel *bannerModel;
    if ([loopScrollView.superview isKindOfClass:[RecommendSectionHeader class]]) {
        bannerModel = _model.bannerTop[index];
    }else if ([loopScrollView.superview isKindOfClass:[RecommendSectionFooter class]]) {
        bannerModel = _model.bannerBottom[index];
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImageWithURL:[NSURL URLWithString:bannerModel.image] placeholder:[DdImageManager banner_placeholderImageBySize:CGSizeMake(kScreenWidth, heightEx(96.0))]];
    return imageView;
}

#pragma mark 刷新推荐列表数据
- (RACCommand *)refreshRecommendData
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSString *url;
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            if ([self.model.type isEqualToString:RecommendTypeRecommend]) {
                url = DdRecommendHotRefreshURL;
                parameters[@"rand"] = @(1);
            }else if ([self.model.type isEqualToString:RecommendTypeLive]) {
                url = DdRecommendLiveRefreshURL;
                parameters[@"rand"] = @(0);
            }else {
                url = [NSString stringWithFormat:@"%@/%@.json", DdRecommendRegionRefreshURL, self.model.param];
                parameters[@"pagesize"] = @(4);
                parameters[@"tid"] = self.model.param;
            }
            
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"build"] = [AppInfo build];
            parameters[@"channel"] = [AppInfo channel];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"plat"] = [AppInfo plat];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"sign"] = [AppInfo sign];
            parameters[@"ts"] = @([AppInfo ts]);
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:url parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSArray *body;
                    if ([self.model.type isEqualToString:RecommendTypeRecommend] || [self.model.type isEqualToString:RecommendTypeLive]) {
                        body = [NSArray modelArrayWithClass:RecommendModel.class json:responseObject[kResponseDataKey]];
                    }else {
                        body = [NSArray modelArrayWithClass:RecommendModel.class json:responseObject[kResponseListKey]];
                    }
                    
                    self.model.body = body;
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
