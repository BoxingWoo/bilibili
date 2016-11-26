//
//  DdVideoReplyCell.h
//  Dilidili
//
//  Created by BoxingWoo on 16/9/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 视频评论单元格
 */
@interface DdVideoReplyCell : UITableViewCell

/** 头像视图 */
@property (nonatomic, weak) YYAnimatedImageView *faceImageView;
/** 等级图片 */
@property (nonatomic, weak) UIImageView *levelImageView;
/** 姓名标签 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 性别图片 */
@property (nonatomic, weak) UIImageView *sexImageView;
/** 楼层标签 */
@property (nonatomic, weak) UILabel *floorLabel;
/** 时间标签 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 内容标签 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 回复按钮 */
@property (nonatomic, weak) UIButton *replyBtn;
/** 点赞按钮 */
@property (nonatomic, weak) UIButton *likeBtn;
/** 更多按钮 */
@property (nonatomic, weak) UIButton *moreBtn;

/** 点赞事件响应 */
@property (nonatomic, strong) RACSubject *likeSubject;
/** 更多事件响应 */
@property (nonatomic, strong) RACSubject *moreSubject;

@end
