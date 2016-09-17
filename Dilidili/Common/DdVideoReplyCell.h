//
//  DdVideoReplyCell.h
//  Dilidili
//
//  Created by BoxingWoo on 16/9/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DdVideoReplyCell : UITableViewCell

@property (nonatomic, weak) YYAnimatedImageView *faceImageView;
@property (nonatomic, weak) UIImageView *levelImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *sexImageView;
@property (nonatomic, weak) UILabel *floorLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIButton *replyBtn;
@property (nonatomic, weak) UIButton *likeBtn;
@property (nonatomic, weak) UIButton *moreBtn;

@property (nonatomic, strong) RACSubject *likeSubject;
@property (nonatomic, strong) RACSubject *moreSubject;

@end
