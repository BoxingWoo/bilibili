//
//  DdVideoReplySubCell.m
//  Dilidili
//
//  Created by BoxingWoo on 16/9/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoReplySubCell.h"

@implementation DdVideoReplySubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = [UIColor grayColor];
        nameLabel.text = @"昵称";
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(12.0);
            make.left.equalTo(self.contentView.mas_left).offset(40.0);
        }];
        UILabel *timeLabel = [[UILabel alloc] init];
        _timeLabel = timeLabel;
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.text = @"0秒前";
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset(8.0);
            make.centerY.equalTo(nameLabel.mas_centerY);
        }];
        UILabel *contentLabel = [[UILabel alloc] init];
        _contentLabel = contentLabel;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = kTextColor;
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-10.0);
            make.top.equalTo(nameLabel.mas_bottom).offset(8.0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-16.0);
        }];
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn = moreBtn;
        moreBtn.adjustsImageWhenHighlighted = NO;
        [moreBtn setImage:[UIImage imageNamed:@"circle_more_ic"] forState:UIControlStateNormal];
        [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            [self.moreSubject sendNext:self];
        }];
        [self.contentView addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentLabel.mas_right);
            make.centerY.equalTo(nameLabel.mas_centerY);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation DdVideoReplyMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton *checkMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkMoreBtn = checkMoreBtn;
        checkMoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [checkMoreBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [self.contentView addSubview:checkMoreBtn];
        [checkMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-18.0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6.0);
        }];
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-10.0);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0);
            make.bottom.equalTo(checkMoreBtn.mas_top).offset(-24.0);
        }];
    }
    return self;
}

@end
