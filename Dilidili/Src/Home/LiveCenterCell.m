//
//  LiveCenterCell.m
//  Dilidili
//
//  Created by iMac on 2016/10/28.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "LiveCenterCell.h"
#import "BSCentralButton.h"

@interface LiveCenterCell ()

@property (nonatomic, copy) NSArray *buttons;

@end

@implementation LiveCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.alignment = UIStackViewAlignmentFill;
        [self.contentView addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        for (NSInteger i = 0; i < 4; i++) {
            BSCentralButton *button = [BSCentralButton buttonWithType:UIButtonTypeCustom andContentSpace:4.0];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.tag = i;
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
                if (_actionSubject) {
                    RACTuple *tuple = RACTuplePack(self, @(x.tag));
                    [self.actionSubject sendNext:tuple];
                }
            }];
            [stackView addArrangedSubview:button];
        }
        _buttons = stackView.arrangedSubviews;
    }
    return self;
}

- (void)setContents:(NSArray *)contents
{
    _contents = contents;
    for (NSInteger i = 0; i < self.buttons.count; i++) {
        BSCentralButton *button = self.buttons[i];
        NSDictionary *dict = nil;
        if (i < contents.count) {
            dict = contents[i];
        }
        [button setImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
        [button setTitle:dict[@"title"] forState:UIControlStateNormal];
    }
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
