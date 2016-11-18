//
//  BangumiViewModel.m
//  Dilidili
//
//  Created by iMac on 2016/11/12.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "BangumiViewModel.h"
#import "DdHTTPSessionManager.h"
#import "DdImageManager.h"

@interface BangumiViewModel ()

@property (nonatomic, assign) CGSize cellSize;  // 单元格大小

@end

@implementation BangumiViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(BangumiListModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark 配置单元格
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[BangumiGirdCell class]]) {
        
        BangumiGirdCell *girdCell = (BangumiGirdCell *)cell;
        UIImage *placeholderImage = [DdImageManager cover_placeholderImageBySize:CGSizeMakeEx(96, 128)];
        [girdCell.coverImageView setImageWithURL:[NSURL URLWithString:self.model.cover] placeholder:placeholderImage options:YYWebImageOptionSetImageWithFadeAnimation progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            
            return [DdImageManager transformImage:image size:girdCell.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageDarkGradient];
            
        } completion:NULL];
        girdCell.onlineLabel.text = [NSString stringWithFormat:@"%lu人在看", self.model.watching_count];
        girdCell.titleLabel.text = self.model.title;
        girdCell.indexLabel.text = [NSString stringWithFormat:@"更新至第%@话", self.model.newest_ep_index];
        
        _cellSize = CGSizeMake(widthEx(96), heightEx(128) + 54);
        
    }else if ([cell isKindOfClass:[BangumiListCell class]]) {
        
        BangumiListCell *listCell = (BangumiListCell *)cell;
        UIImage *placeholderImage = [DdImageManager cover_placeholderImageBySize:CGSizeMake(kScreenWidth - 20, (kScreenWidth - 20) * 0.32)];
        [listCell.coverImageView setImageWithURL:[NSURL URLWithString:self.model.cover] placeholder:placeholderImage options:YYWebImageOptionSetImageWithFadeAnimation progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            
            return [DdImageManager transformImage:image size:listCell.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageStyleNone];
            
        } completion:NULL];
        listCell.titleLabel.text = self.model.title;
        NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:[self.model.desc stringByReplacingOccurrencesOfString:@" " withString:@"\n"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4.0;
        [desc addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, desc.string.length)];
        listCell.descLabel.attributedText = desc;
        
        NSLayoutConstraint *tempLayoutConstraint = [NSLayoutConstraint constraintWithItem:listCell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth - 20];
        [listCell.contentView addConstraint:tempLayoutConstraint];
        _cellSize = [listCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [listCell.contentView removeConstraint:tempLayoutConstraint];
    }
}

#pragma mark 单元格大小
- (CGSize)cellSize:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (CGSizeEqualToSize(_cellSize, CGSizeZero)) {
        [self configureCell:cell atIndexPath:indexPath];
    }
    return self.cellSize;
}

#pragma mark 请求番剧索引列表数据
+ (RACCommand *)requestBangumiIndexData:(BOOL)forceReload
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"build"] = [AppInfo build];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
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
            [manager GET:DdBangumiIndexURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSDictionary *result = responseObject[@"result"];
                    NSDictionary *ad = @{@"body":[NSArray modelArrayWithClass:[BangumiBannerModel class] json:result[@"ad"][@"body"]], @"head":[NSArray modelArrayWithClass:[BangumiBannerModel class] json:result[@"ad"][@"head"]]};
                    NSArray *previous = [NSArray modelArrayWithClass:[BangumiListModel class] json:result[@"previous"][@"list"]];
                    NSArray *serializing = [NSArray modelArrayWithClass:[BangumiListModel class] json:result[@"serializing"]];
                    RACTuple *tuple = RACTuplePack(serializing, previous, ad, result[@"previous"][@"season"]);
                    [subscriber sendNext:tuple];
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

#pragma mark 请求番剧推荐列表数据
+ (RACCommand *)requestBangumiRecommendData:(BOOL)forceReload
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"build"] = @"3970";
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"season_id"] = @"3287";
            parameters[@"sign"] = @"e9cd094fb06a236206a5878b948f6286";
            parameters[@"ts"] = @(1478923224);
            parameters[@"type"] = @"bangumi";
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
            [manager GET:DdBangumiRecommendURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSArray *result = [NSArray modelArrayWithClass:[BangumiListModel class] json:responseObject[@"result"]];
                    [subscriber sendNext:result];
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
