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


@interface DdReplyViewModel ()

/** 单元格高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation DdReplyViewModel

#pragma mark 构造方法
- (instancetype)initWithModel:(DdReplyModel *)model
{
    if (self = [super init]) {
        _model = model;
        _isSub = NO;
        _isHot = NO;
        _cellHeight = 0;
        NSMutableArray *replies = [NSMutableArray array];
        for (DdReplyModel *replyModel in model.replies) {
            DdReplyViewModel *replyViewModel = [[DdReplyViewModel alloc] initWithModel:replyModel];
            replyViewModel.isSub = YES;
            [replies addObject:replyViewModel];
        }
        _replies = replies;
    }
    return self;
}

#pragma mark 计算布局
- (void)layout
{
    if (_cellHeight != 0) return;
    UITableViewCell *cell;
    if (!_isSub) {
        DdVideoReplyCell *replyCell = [[DdVideoReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoReplyCellID];
        replyCell.contentLabel.text = self.model.content.message;
        cell = replyCell;
    }else {
        DdVideoReplySubCell *subCell = [[DdVideoReplySubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoReplySubCellID];
        subCell.contentLabel.text = self.model.content.message;
        cell = subCell;
    }
    
    NSLayoutConstraint *tempWidthConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenWidth];
    [cell.contentView addConstraint:tempWidthConstraint];
    _cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1 / kScreenScale;
    [cell removeConstraint:tempWidthConstraint];
}

#pragma mark 配置单元格
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DdVideoReplyCell *replyCell = (DdVideoReplyCell *)cell;
        [replyCell.faceImageView setImageWithURL:[NSURL URLWithString:self.model.member.avatar] placeholder:[DdImageManager face_placeholderImage] options:YYWebImageOptionIgnoreDiskCache progress:NULL transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            
            UIImage *transformImage = [image imageByResizeToSize:CGSizeMake(replyCell.faceImageView.width * kScreenScale, replyCell.faceImageView.width * kScreenScale)];
            transformImage = [transformImage imageByRoundCornerRadius:transformImage.size.width / 2];
            return transformImage;
            
        } completion:NULL];
        replyCell.nameLabel.text = self.model.member.uname;
        replyCell.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"misc_level_colorfulLv%@", self.model.member.level_info[@"current_level"]]];
        replyCell.floorLabel.text = [NSString stringWithFormat:@"#%li", self.model.floor];
        replyCell.timeLabel.text = [BSTimeCalculate localDateFormatStringWithTimeInterval:self.model.ctime style:BSDateFormatDescription];
        replyCell.contentLabel.text = self.model.content.message;
        if (_isHot) {
            replyCell.replyBtn.hidden = NO;
            [replyCell.replyBtn setTitle:[NSString stringWithFormat:@" %@", [DdFormatter stringForCount:self.model.count]] forState:UIControlStateNormal];
        }else {
            replyCell.replyBtn.hidden = YES;
        }
        [replyCell.likeBtn setTitle:[NSString stringWithFormat:@" %@", [DdFormatter stringForCount:self.model.like]] forState:UIControlStateNormal];
        replyCell.likeBtn.selected = self.model.isliked;
    }else {
        DdVideoReplySubCell *subCell = (DdVideoReplySubCell *)cell;
        subCell.nameLabel.text = self.model.member.uname;
        subCell.timeLabel.text = [BSTimeCalculate localDateFormatStringWithTimeInterval:self.model.ctime style:BSDateFormatDescription];
        subCell.contentLabel.text = self.model.content.message;
    }
}

#pragma mark 请求评论数据
+ (RACCommand *)requestReplyDataByOid:(NSString *)oid pageNum:(NSUInteger)pageNum
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"_device"] = [AppInfo mobi_app];
            parameters[@"_hwid"] = @"2e771212f4b4dc67";
            parameters[@"_ulv"] = @(0);
            parameters[@"access_key"] = @"";
            parameters[@"oid"] = oid;
            parameters[@"appkey"] = [AppInfo appkey];
            parameters[@"appver"] = [AppInfo appver];
            parameters[@"build"] = [AppInfo build];
            parameters[@"platform"] = [AppInfo platform];
            parameters[@"pn"] = @(pageNum);
            parameters[@"ps"] = @(kDefaultPageSize);
            parameters[@"sign"] = [AppInfo signParameters:nil byTimeStamp:0];
            parameters[@"sort"] = @(0);
            parameters[@"type"] = @(1);
            
            DdHTTPSessionManager *manager = [DdHTTPSessionManager manager];
            [manager GET:DdVideoReplyURL parameters:parameters complection:^(ResponseCode code, NSDictionary *responseObject, NSError *error) {
                if (code == 0) {
                    NSDictionary *dict = responseObject[kResponseDataKey];
                    NSArray *hots = [NSArray modelArrayWithClass:DdReplyModel.class json:dict[@"hots"]];
                    NSArray *replies = [NSArray modelArrayWithClass:DdReplyModel.class json:dict[@"replies"]];
                    NSDictionary *page = dict[@"page"];
                    RACTuple *tuple = RACTuplePack(hots, replies, page);
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

@end
