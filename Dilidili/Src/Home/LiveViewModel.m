//
//  LiveViewModel.m
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveViewModel.h"
#import "DdHTTPSessionManager.h"
#import "DdImageManager.h"

@implementation LiveViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(LiveListModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark 配置单元格
- (void)configureCell:(LiveCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIImage *placeholderImage = [DdImageManager cover_placeholderImageBySize:CGSizeMakeEx(144, 92)];
    LiveModel *model = self.model.lives[indexPath.item];
    [cell.coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:placeholderImage options:YYWebImageOptionSetImageWithFadeAnimation progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        
        return [DdImageManager transformImage:image size:cell.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageDarkGradient];
        
    } completion:NULL];
    cell.nameLabel.text = model.owner.name;
    [cell.onlineBtn setTitle:[DdFormatter stringForCount:model.online] forState:UIControlStateNormal];
    NSString *area = [NSString stringWithFormat:@"#%@#", model.area];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", area, model.title]];
    [title addAttribute:NSForegroundColorAttributeName value:kThemeColor range:NSMakeRange(0, area.length)];
    cell.titleLabel.attributedText = title;
    
    NSUInteger lastOne = 0;
    if (indexPath.section == 0) {
        lastOne = self.model.lives.count - 1;
    }else {
        lastOne = 3;
    }
    if (lastOne == indexPath.item) {
        LiveRefreshCell *refreshCell = (LiveRefreshCell *)cell;
        refreshCell.refreshBtn.tag = indexPath.section;
    }
}

#pragma mark 配置直播列表头部视图
- (void)configureSectionHeader:(LiveSectionHeader *)sectionHeader atIndex:(NSInteger)section
{
    LivePartitionModel *partition = self.model.partition;
    [sectionHeader.iconImageView setImageURL:[NSURL URLWithString:partition.src]];
    sectionHeader.titleLabel.text = partition.name;
    NSString *count = [NSString stringWithFormat:@"%lu", partition.count];
    NSString *more = [NSString stringWithFormat:@"当前%@个直播，进去看看", count];
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:more];
    [attTitle addAttribute:NSForegroundColorAttributeName value:kThemeColor range:[more rangeOfString:count]];
    [sectionHeader.moreBtn setAttributedTitle:attTitle forState:UIControlStateNormal];
    sectionHeader.moreBtn.tag = section;
}

#pragma mark 刷新直播列表数据
- (RACCommand *)refreshLiveDataAtIndex:(NSInteger)section
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *url;
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            if (section == 0) {
                url = DdLiveRecommendRefreshURL;
                parameters[@"sign"] = @"39e3b557397f1026ddb239731c213004";
                parameters[@"ts"] = @(1475576802);
            }else {
                url = DdLiveRefreshURL;
                parameters[@"area"] = self.model.partition.area;
                parameters[@"sign"] = [AppInfo sign];
                parameters[@"ts"] = @([AppInfo ts]);
            }
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"build"] = [AppInfo build];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"platform"] = [AppInfo platform];
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:url parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    if (section == 0) {
                        NSDictionary *dict = responseObject[kResponseDataKey];
                        self.model.lives = [NSArray modelArrayWithClass:[LiveModel class] json:dict[@"lives"]];
                        self.model.banner_data = [NSArray modelArrayWithClass:[LiveModel class] json:dict[@"banner_data"]];
                        self.model.partition.count = [[dict[@"partition"] objectForKey:@"count"] unsignedIntegerValue];
                    }else {
                        self.model.lives = [NSArray modelArrayWithClass:[LiveModel class] json:responseObject[kResponseDataKey]];
                    }
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

#pragma mark 请求直播模块数据
+ (RACCommand *)requestLiveData:(BOOL)forceReload
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //请求直播列表推荐数据
        RACSignal *recommendedSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"build"] = [AppInfo build];
            parameters[@"buvid"] = [AppInfo buvid];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"scale"] = @2;
            parameters[@"sign"] = @"62a5dd5d2012b839dfde09f6eee471d7";
            parameters[@"ts"] = @(1475576150);
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
#ifdef DEBUG
            if (forceReload) {
                manager.cachePolicy = RequestReloadIgnoringCacheData;
            }else {
                manager.cachePolicy = RequestReturnCacheDataDontLoad;
            }
#else
            manager.cachePolicy = RequestReloadIgnoringCacheData;
#endif
            [manager GET:DdLiveRecommendURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSDictionary *recommend_data = [responseObject[kResponseDataKey] objectForKey:@"recommend_data"];
                    LiveListModel *recommendedModel = [LiveListModel modelWithDictionary:recommend_data];
                    [subscriber sendNext:recommendedModel];
                }else {
                    [subscriber sendError:error];
                }
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        //请求直播列表数据
        RACSignal *listSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"scale"] = @2;
            parameters[@"device"] = [AppInfo device];
            parameters[@"platform"] = [AppInfo platform];
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
#ifdef DEBUG
            if (forceReload) {
                manager.cachePolicy = RequestReloadIgnoringCacheData;
            }else {
                manager.cachePolicy = RequestReturnCacheDataDontLoad;
            }
#else
            manager.cachePolicy = RequestReloadIgnoringCacheData;
#endif
            [manager GET:DdLiveListURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSDictionary *dict = responseObject[kResponseDataKey];
                    NSArray *banners = [NSArray modelArrayWithClass:[LiveBannerModel class] json:dict[@"banner"]];
                    NSArray *partitions = [NSArray modelArrayWithClass:[LiveListModel class] json:dict[@"partitions"]];
                    RACTuple *tuple = RACTuplePack(partitions, banners);
                    [subscriber sendNext:tuple];
                }else {
                    [subscriber sendError:error];
                }
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        return [RACSignal combineLatest:@[recommendedSignal, listSignal]];
    }];
}

@end
