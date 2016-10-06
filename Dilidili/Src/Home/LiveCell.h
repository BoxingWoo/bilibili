//
//  LiveCell.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIButton *onlineBtn;
@property (nonatomic, weak) UILabel *titleLabel;

@end


@interface LiveRefreshCell : LiveCell

@property (nonatomic, weak) UIButton *refreshBtn;

@end
