//
//  DdVideoReplySubCell.h
//  Dilidili
//
//  Created by BoxingWoo on 16/9/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 视频评论回复单元格
 */
@interface DdVideoReplySubCell : UITableViewCell

/** 姓名标签 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间标签 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 内容标签 */
@property (nonatomic, weak) UILabel *contentLabel;
/** 更多按钮 */
@property (nonatomic, weak) UIButton *moreBtn;

/** 更多事件响应 */
@property (nonatomic, strong) RACSubject *moreSubject;

@end

/**
 视屏更多评论单元格
 */
@interface DdVideoReplyMoreCell : DdVideoReplySubCell

/** 查看更多按钮 */
@property (nonatomic, weak) UIButton *checkMoreBtn;

@end
