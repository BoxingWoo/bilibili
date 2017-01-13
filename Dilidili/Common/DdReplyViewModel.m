//
//  DdReplyViewModel.m
//  Dilidili
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdReplyViewModel.h"
#import "DdHTTPSessionManager.h"
#import "DdImageManager.h"
#import "BSTimeCalculate.h"
#import "DdFormatter.h"
#import "UITableView+FDTemplateLayoutCell.h"

@implementation DdReplyViewModel

- (NSMutableArray<DdReplyListViewModel *> *)replies
{
    if (!_replies) {
        _replies = [[NSMutableArray alloc] init];
    }
    return _replies;
}

#pragma mark 配置单元格
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath isHot:(BOOL)isHot
{
    DdReplyListViewModel *viewModel;
    if (isHot) {
        viewModel = self.hots[indexPath.section];
    }else {
        viewModel = self.replies[indexPath.section];
    }
    BOOL isSub = NO;
    if (indexPath.row != 0) {
        isSub = YES;
        viewModel = viewModel.replies[indexPath.row - 1];
    }
    
    if (!isSub) {
        DdVideoReplyCell *replyCell = (DdVideoReplyCell *)cell;
        [replyCell.faceImageView setImageWithURL:[NSURL URLWithString:viewModel.model.member.avatar] placeholder:[DdImageManager face_placeholderImage] options:YYWebImageOptionIgnoreDiskCache progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            
            UIImage *transformImage = [image imageByResizeToSize:CGSizeMake(replyCell.faceImageView.width * kScreenScale, replyCell.faceImageView.width * kScreenScale)];
            transformImage = [transformImage imageByRoundCornerRadius:transformImage.size.width / 2];
            return transformImage;
            
        } completion:NULL];
        replyCell.nameLabel.text = viewModel.model.member.uname;
        replyCell.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"misc_level_colorfulLv%@", viewModel.model.member.level_info[@"current_level"]]];
        replyCell.floorLabel.text = [NSString stringWithFormat:@"#%li", viewModel.model.floor];
        replyCell.timeLabel.text = [BSTimeCalculate localDateFormatStringWithTimeInterval:viewModel.model.ctime style:BSDateFormatDescription];
        replyCell.contentLabel.text = viewModel.model.content.message;
        if (isHot) {
            replyCell.replyBtn.hidden = NO;
            [replyCell.replyBtn setTitle:[NSString stringWithFormat:@" %@", [DdFormatter stringForCount:viewModel.model.count]] forState:UIControlStateNormal];
        }else {
            replyCell.replyBtn.hidden = YES;
        }
        [replyCell.likeBtn setTitle:[NSString stringWithFormat:@" %@", [DdFormatter stringForCount:viewModel.model.like]] forState:UIControlStateNormal];
        replyCell.likeBtn.selected = viewModel.model.isliked;
    }else {
        DdVideoReplySubCell *subCell = (DdVideoReplySubCell *)cell;
        subCell.nameLabel.text = viewModel.model.member.uname;
        subCell.timeLabel.text = [BSTimeCalculate localDateFormatStringWithTimeInterval:viewModel.model.ctime style:BSDateFormatDescription];
        subCell.contentLabel.text = viewModel.model.content.message;
    }
}

#pragma mark 单元格高度
- (CGFloat)heightForCellOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath isHot:(BOOL)isHot
{
    DdReplyListViewModel *viewModel;
    if (isHot) {
        viewModel = self.hots[indexPath.section];
    }else {
        viewModel = self.replies[indexPath.section];
    }
    BOOL isSub = NO;
    if (indexPath.row != 0) {
        isSub = YES;
        viewModel = viewModel.replies[indexPath.row - 1];
    }
    NSString *identifier = nil;
    if (!isSub) {
        identifier = kvideoReplyCellID;
    }else {
        identifier = kvideoReplySubCellID;
    }
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath isHot:isHot];
    }];
}

#pragma mark 请求评论数据
- (RACCommand *)requestReplyDataByPageNum:(NSUInteger)pageNum
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"_device"] = [AppInfo mobi_app];
            parameters[@"_hwid"] = @"2e771212f4b4dc67";
            parameters[@"_ulv"] = @(0);
            parameters[@"access_key"] = @"";
            parameters[@"oid"] = self.oid;
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"appver"] = [AppInfo appver];
            parameters[@"build"] = [AppInfo build];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"pn"] = @(pageNum);
            parameters[@"ps"] = @(kDefaultPageSize);
            parameters[@"sign"] = [AppInfo sign];
            parameters[@"sort"] = @(0);
            parameters[@"type"] = @(1);
            
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:DdVideoReplyURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSDictionary *dict = responseObject[kResponseDataKey];
                    
                    NSArray *hots = [NSArray modelArrayWithClass:DdReplyModel.class json:dict[@"hots"]];
                    NSMutableArray *hotLists = [[NSMutableArray alloc] init];
                    for (DdReplyModel *model in hots) {
                        DdReplyListViewModel *viewModel = [[DdReplyListViewModel alloc] initWithModel:model];
                        [hotLists addObject:viewModel];
                    }
                    self.hots = hotLists;
                    
                    NSArray *replies = [NSArray modelArrayWithClass:DdReplyModel.class json:dict[@"replies"]];
                    NSMutableArray *replyLists = [[NSMutableArray alloc] init];
                    for (DdReplyModel *model in replies) {
                        DdReplyListViewModel *viewModel = [[DdReplyListViewModel alloc] initWithModel:model];
                        [replyLists addObject:viewModel];
                    }
                    if (pageNum == 1) {
                        [self.replies removeAllObjects];
                    }
                    [self.replies addObjectsFromArray:replyLists];
                    
                    self.page = dict[@"page"];
                    [subscriber sendNext:nil];
                }else {
                    [subscriber sendError:error];
                }
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
        
        self.replySignal = signal;
        return signal;
    }];
}

@end
