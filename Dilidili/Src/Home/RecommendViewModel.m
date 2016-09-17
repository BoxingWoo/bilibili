//
//  RecommendViewModel.m
//  Dilidili
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "RecommendViewModel.h"
#import "DdHTTPSessionManager.h"
#import "DdImageManager.h"

@interface RecommendViewModel () <BSLoopScrollViewDataSource>

@end

@implementation RecommendViewModel

- (instancetype)initWithModel:(RecommendListModel *)model
{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

#pragma mark 配置单元格
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.model.style isEqualToString:RecommendStyleSmall]) {
        
        RecommendScrollCell *scrollCell = (RecommendScrollCell *)cell;
        NSMutableArray *contentViews = [NSMutableArray array];
        for (NSInteger i = 0; i < self.model.body.count; i++) {
            RecommendModel *model = self.model.body[i];
            RecommendScrollContentView *contentView = [scrollCell dequeueReusableContentViewforIndex:i];
            [contentView.coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:[DdImageManager cover_placeholderImageBySize:CGSizeMakeEx(158.0, 90.0)] options:YYWebImageOptionSetImageWithFadeAnimation progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                
                return [DdImageManager transformImage:image size:contentView.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageStyleNone];

            } completion:NULL];
            contentView.titleLabel.text = model.title;
            contentView.indexPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            [contentViews addObject:contentView];
        }
        scrollCell.contentViews = contentViews;
        
    }else {
        
        RecommendModel *model = self.model.body[indexPath.item];
        if ([self.model.type isEqualToString:RecommendTypeLive]) {
            RecommendLiveCell *liveCell = (RecommendLiveCell *)cell;
            [liveCell.coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:[DdImageManager live_placeholderImageBySize:CGSizeMakeEx(146.0, 92.0)] options:YYWebImageOptionSetImageWithFadeAnimation progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                
                return [DdImageManager transformImage:image size:liveCell.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageDarkGradient];
                
            } completion:NULL];
            [liveCell.faceImageView setImageWithURL:[NSURL URLWithString:model.face] placeholder:[DdImageManager face_placeholderImage] options:YYWebImageOptionIgnoreDiskCache progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                
                UIImage *transformImage = [image imageByResizeToSize:CGSizeMake(liveCell.faceImageView.width * kScreenScale, liveCell.faceImageView.height * kScreenScale)];
                transformImage = [transformImage imageByRoundCornerRadius:transformImage.size.width / 2 borderWidth:2.0 borderColor:[UIColor whiteColor]];
                return transformImage;
                
            } completion:NULL];
            liveCell.nameLabel.text = model.name;
            liveCell.onlineLabel.text = [DdFormatter stringForCount:model.online];
            liveCell.titleLabel.text = model.title;
            if (indexPath.item == self.model.body.count - 1) {
                liveCell.refreshBtn.hidden = NO;
                liveCell.refreshBtn.tag = indexPath.section;
            }else {
                liveCell.refreshBtn.hidden = YES;
            }
//            liveCell.refreshBtn.enabled = YES;
//            [liveCell.refreshBtn.layer pop_removeAllAnimations];
//            liveCell.refreshBtn.layer.transform = CATransform3DIdentity;
        }else if ([self.model.type isEqualToString:RecommendTypeBangumi]) {
            RecommendBangumiCell *bangumiCell = (RecommendBangumiCell *)cell;
            [bangumiCell.coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:[DdImageManager cover_placeholderImageBySize:CGSizeMakeEx(146.0, 92.0)] options:0 progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                
                return [DdImageManager transformImage:image size:bangumiCell.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageDarkGradient];
                
            } completion:NULL];
            bangumiCell.titleLabel.text = model.title;
            bangumiCell.indexLabel.text = [NSString stringWithFormat:@"第%@话", model.index];
        }else {
            RecommendCell *normalCell = (RecommendCell *)cell;
            [normalCell.coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:[DdImageManager cover_placeholderImageBySize:CGSizeMakeEx(146.0, 92.0)] options:YYWebImageOptionSetImageWithFadeAnimation progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                
                return [DdImageManager transformImage:image size:normalCell.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageDarkGradient];
                
            } completion:NULL];
            normalCell.titleLabel.text = model.title;
            [normalCell.playCount setTitle:[DdFormatter stringForCount:model.play] forState:UIControlStateNormal];
            [normalCell.danmakuCount setTitle:[DdFormatter stringForCount:model.danmaku] forState:UIControlStateNormal];
            if (indexPath.item == self.model.body.count - 1) {
                RecommendRefreshCell *refreshCell = (RecommendRefreshCell *)normalCell;
                refreshCell.refreshBtn.tag = indexPath.section;
//                refreshCell.refreshBtn.enabled = YES;
//                [refreshCell.refreshBtn.layer pop_removeAllAnimations];
//                refreshCell.refreshBtn.layer.transform = CATransform3DIdentity;
            }
        }
        
    }
}

#pragma mark 配置推荐列表头部视图
- (void)configureSectionHeader:(RecommendSectionHeader *)sectionHeader atIndex:(NSInteger)section
{
    sectionHeader.titleLabel.text = self.model.title;
    
    if ([self.model.type isEqualToString:RecommendTypeLive]) {
        sectionHeader.arrowImageView.image = [UIImage imageNamed:@"common_rightArrowShadow"];
    }else {
        sectionHeader.arrowImageView.image = [UIImage imageNamed:@"common_rightArrowGray"];
    }
    
    if ([self.model.type isEqualToString:RecommendTypeRecommend]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"hd_home_recommend"];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"排行榜" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:254 / 255.0 green:194 / 255.0 blue:51 / 255.0 alpha:1.0]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
        [sectionHeader.moreBtn setImage:[UIImage imageNamed:@"hd_home_rank"] forState:UIControlStateNormal];
    }else if ([self.model.type isEqualToString:RecommendTypeLive]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"home_region_icon_live"];
        NSString *str = [NSString stringWithFormat:@"当前%@个直播，进去看看", self.model.ext[@"live_count"]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [attStr addAttribute:NSForegroundColorAttributeName value:kThemeColor range:[str rangeOfString:[self.model.ext[@"live_count"] stringValue]]];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }else if ([self.model.type isEqualToString:RecommendTypeBangumi]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"category_cinema_icon"];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"更多番剧" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }else if ([self.model.type isEqualToString:RecommendTypeActivity]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"home_recommend_activity"];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"更多活动" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }else if ([self.model.type isEqualToString:RecommendTypeRegion]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_region_icon_%@", self.model.param]];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"更多%@", [self.model.title substringToIndex:self.model.title.length - 1]] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
    if (self.model.bannerTop.count > 0) {
        RecommendBannerSectionHeader *bannerSecionHeader = (RecommendBannerSectionHeader *)sectionHeader;
        bannerSecionHeader.loopScrollView.tag = section;
        bannerSecionHeader.loopScrollView.dataSource = self;
        [bannerSecionHeader.loopScrollView reloadData];
    }
}

#pragma mark 配置推荐列表尾部视图
- (void)configureSectionFooter:(RecommendSectionFooter *)sectionFooter atIndex:(NSInteger)section
{
    if (self.model.bannerBottom.count > 0) {
        sectionFooter.loopScrollView.tag = section;
        sectionFooter.loopScrollView.dataSource = self;
        [sectionFooter.loopScrollView reloadData];
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
            parameters[@"sign"] = [AppInfo signParameters:nil byTimeStamp:0];
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

#pragma mark 请求推荐模块数据
+ (RACCommand *)requestRecommendData:(BOOL)forceReload
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"warm"] = 0;
            parameters[@"actionKey"] = [AppInfo actionKey];
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"build"] = [AppInfo build];
            parameters[@"channel"] = [AppInfo channel];
            parameters[@"device"] = [AppInfo device];
            parameters[@"mobi_app"] = [AppInfo mobi_app];
            parameters[@"plat"] = [AppInfo plat];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"sign"] = [AppInfo signParameters:nil byTimeStamp:0];
            parameters[@"ts"] = @([AppInfo ts]);
            
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
            [manager GET:DdRecommendListURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSArray *modelArr = [NSArray modelArrayWithClass:RecommendListModel.class json:responseObject[kResponseDataKey]];
                    [subscriber sendNext:modelArr];
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
