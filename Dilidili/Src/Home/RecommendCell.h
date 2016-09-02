//
//  RecommendCell.h
//  Dilidili
//
//  Created by iMac on 16/8/27.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *playCount;
@property (nonatomic, weak) UIButton *danmakuCount;

@end


@interface RecommendRefreshCell : RecommendCell

@property (nonatomic, weak) UIButton *refreshBtn;

@end