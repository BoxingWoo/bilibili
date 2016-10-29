//
//  LiveRecommendView.h
//  Dilidili
//
//  Created by iMac on 2016/10/25.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveRecommendView : UIControl

@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, weak) YYAnimatedImageView *faceImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *onlineLabel;

@end
