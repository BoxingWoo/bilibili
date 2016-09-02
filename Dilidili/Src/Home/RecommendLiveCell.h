//
//  RecommendLiveCell.h
//  Dilidili
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendLiveCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, weak) UIImageView *faceImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *onlineLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *refreshBtn;

@end
