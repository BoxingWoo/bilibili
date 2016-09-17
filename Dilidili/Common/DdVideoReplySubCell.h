//
//  DdVideoReplySubCell.h
//  Dilidili
//
//  Created by BoxingWoo on 16/9/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DdVideoReplySubCell : UITableViewCell

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIButton *moreBtn;

@property (nonatomic, strong) RACSubject *moreSubject;

@end


@interface DdVideoReplyMoreCell : DdVideoReplySubCell

@property (nonatomic, weak) UIButton *checkMoreBtn;

@end
