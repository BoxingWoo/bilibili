//
//  DdVideoReplyCell.m
//  Dilidili
//
//  Created by BoxingWoo on 16/9/16.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdVideoReplyCell.h"

@implementation DdVideoReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layoutMargins = UIEdgeInsetsZero;
        self.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0);
        YYAnimatedImageView *faceImageView = [[YYAnimatedImageView alloc] init];
        _faceImageView = faceImageView;
        [self.contentView addSubview:faceImageView];
        [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10.0);
            make.left.equalTo(self.contentView.mas_left).offset(8.0);
            make.width.height.mas_equalTo(30.0);
        }];
        UIImageView *levelImageView = [[UIImageView alloc] init];
        _levelImageView = levelImageView;
        [self.contentView addSubview:levelImageView];
        [levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(faceImageView.mas_bottom).offset(3.0);
            make.centerX.equalTo(faceImageView.mas_centerX);
            make.width.mas_equalTo(16.0);
            make.height.mas_equalTo(8.0);
        }];
        UILabel *nameLabel = [[UILabel alloc] init];
        _nameLabel = nameLabel;
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = kTextColor;
        nameLabel.text = @"昵称";
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(faceImageView.mas_right).offset(6.0);
            make.top.equalTo(self.contentView.mas_top).offset(12.0);
        }];
        UIImageView *sexImageView = [[UIImageView alloc] init];
        _sexImageView = sexImageView;
        [self.contentView addSubview:sexImageView];
        [sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset(4.0);
            make.centerY.equalTo(nameLabel.mas_centerY);
            make.width.height.mas_equalTo(10.0);
        }];
        UILabel *floorLabel = [[UILabel alloc] init];
        _floorLabel = floorLabel;
        floorLabel.font = [UIFont systemFontOfSize:11];
        floorLabel.textColor = [UIColor lightGrayColor];
        floorLabel.text = @"#000";
        [self.contentView addSubview:floorLabel];
        [floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_left);
            make.top.equalTo(nameLabel.mas_bottom);
        }];
        UILabel *timeLabel = [[UILabel alloc] init];
        _timeLabel = timeLabel;
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.text = @"0秒前";
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(floorLabel.mas_right).offset(6.0);
            make.top.equalTo(floorLabel.mas_top);
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
            make.top.equalTo(timeLabel.mas_bottom).offset(4.0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-24.0);
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
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn = likeBtn;
        likeBtn.adjustsImageWhenHighlighted = NO;
        likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"misc_like_ico"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"misc_like_s_ico"] forState:UIControlStateSelected];
        [[likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id  _Nullable x) {
            [self.likeSubject sendNext:self];
        }];
        [self.contentView addSubview:likeBtn];
        [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moreBtn.mas_left).offset(-8.0);
            make.centerY.equalTo(moreBtn.mas_centerY);
        }];
        
        UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyBtn = replyBtn;
        replyBtn.adjustsImageWhenHighlighted = NO;
        replyBtn.tintColor = kThemeColor;
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [replyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        UIImage *replyImage = [[UIImage imageNamed:@"circle_reply_ic"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [replyBtn setImage:replyImage forState:UIControlStateNormal];
        [self.contentView addSubview:replyBtn];
        [replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(likeBtn.mas_left).offset(-8.0);
            make.centerY.equalTo(moreBtn.mas_centerY);
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
