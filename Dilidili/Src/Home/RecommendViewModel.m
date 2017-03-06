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

@implementation RecommendViewModel

#pragma mark 配置单元格
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RecommendListViewModel *viewModel = self.dataArr[indexPath.section];
    if ([viewModel.model.style isEqualToString:RecommendStyleSmall]) {
        
        RecommendScrollCell *scrollCell = (RecommendScrollCell *)cell;
        NSMutableArray *contentViews = [NSMutableArray array];
        for (NSInteger i = 0; i < viewModel.model.body.count; i++) {
            RecommendModel *model = viewModel.model.body[i];
            RecommendScrollContentView *contentView = [scrollCell dequeueReusableContentViewforIndex:i];
            [contentView.coverImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholder:[DdImageManager activity_placeholderImageBySize:CGSizeMakeEx(158.0, 90.0)] options:YYWebImageOptionSetImageWithFadeAnimation progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                
                return [DdImageManager transformImage:image size:contentView.coverImageView.size cornerRadius:kCoverCornerRadius style:DdImageStyleNone];

            } completion:NULL];
            contentView.titleLabel.text = model.title;
            contentView.indexPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            [contentViews addObject:contentView];
        }
        scrollCell.contentViews = contentViews;
        
    }else {
        
        RecommendModel *model = viewModel.model.body[indexPath.item];
        if ([viewModel.model.type isEqualToString:RecommendTypeLive]) {
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
            if (indexPath.item == viewModel.model.body.count - 1) {
                liveCell.refreshBtn.hidden = NO;
                liveCell.refreshBtn.tag = indexPath.section;
            }else {
                liveCell.refreshBtn.hidden = YES;
            }
        }else if ([viewModel.model.type isEqualToString:RecommendTypeBangumi]) {
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
            if (indexPath.item == viewModel.model.body.count - 1) {
                RecommendRefreshCell *refreshCell = (RecommendRefreshCell *)normalCell;
                refreshCell.refreshBtn.tag = indexPath.section;
            }
        }
    }
}

#pragma mark 配置推荐列表头部视图
- (void)configureSectionHeader:(RecommendSectionHeader *)sectionHeader atIndex:(NSInteger)section
{
    RecommendListViewModel *viewModel = self.dataArr[section];
    sectionHeader.titleLabel.text = viewModel.model.title;
    
    if ([viewModel.model.type isEqualToString:RecommendTypeLive]) {
        sectionHeader.arrowImageView.image = [UIImage imageNamed:@"common_rightArrowShadow"];
    }else {
        sectionHeader.arrowImageView.image = [UIImage imageNamed:@"common_rightArrowGray"];
    }
    
    if ([viewModel.model.type isEqualToString:RecommendTypeRecommend]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"hd_home_recommend"];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"排行榜" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:254 / 255.0 green:194 / 255.0 blue:51 / 255.0 alpha:1.0]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
        [sectionHeader.moreBtn setImage:[UIImage imageNamed:@"hd_home_rank"] forState:UIControlStateNormal];
    }else if ([viewModel.model.type isEqualToString:RecommendTypeLive]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"home_region_icon_live"];
        NSString *str = [NSString stringWithFormat:@"当前%@个直播，进去看看", viewModel.model.ext[@"live_count"]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [attStr addAttribute:NSForegroundColorAttributeName value:kThemeColor range:[str rangeOfString:[viewModel.model.ext[@"live_count"] stringValue]]];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }else if ([viewModel.model.type isEqualToString:RecommendTypeBangumi]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"category_cinema_icon"];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"更多番剧" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }else if ([viewModel.model.type isEqualToString:RecommendTypeActivity]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:@"home_recommend_activity"];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"更多活动" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }else if ([viewModel.model.type isEqualToString:RecommendTypeRegion]) {
        sectionHeader.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_region_icon_%@", viewModel.model.param]];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"更多%@", [viewModel.model.title substringToIndex:viewModel.model.title.length - 1]] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [sectionHeader.moreBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    }
    
    if (viewModel.model.bannerTop.count > 0) {
        RecommendBannerSectionHeader *bannerSecionHeader = (RecommendBannerSectionHeader *)sectionHeader;
        bannerSecionHeader.loopScrollView.tag = section;
        bannerSecionHeader.loopScrollView.dataSource = viewModel;
        [bannerSecionHeader.loopScrollView reloadData];
    }
}

#pragma mark 配置推荐列表尾部视图
- (void)configureSectionFooter:(RecommendSectionFooter *)sectionFooter atIndex:(NSInteger)section
{
    RecommendListViewModel *viewModel = self.dataArr[section];
    if (viewModel.model.bannerBottom.count > 0) {
        sectionFooter.loopScrollView.tag = section;
        sectionFooter.loopScrollView.dataSource = viewModel;
        [sectionFooter.loopScrollView reloadData];
    }
}

#pragma mark 请求推荐模块数据
- (RACCommand *)requestRecommendData:(BOOL)forceReload
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
            parameters[@"sign"] = [AppInfo sign];
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
            @weakify(self);
            [manager GET:DdRecommendListURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                @strongify(self);
                if (code == 0) {
                    NSArray *modelArr = [NSArray modelArrayWithClass:RecommendListModel.class json:responseObject[kResponseDataKey]];
                    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
                    for (RecommendListModel *model in modelArr) {
                        RecommendListViewModel *viewModel = [[RecommendListViewModel alloc] initWithModel:model];
                        [dataArr addObject:viewModel];
                    }
                    self.dataArr = dataArr;
                    [subscriber sendNext:self.dataArr];
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
