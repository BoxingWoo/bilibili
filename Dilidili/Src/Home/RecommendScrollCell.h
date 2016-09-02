//
//  RecommendScrollCell.h
//  Dilidili
//
//  Created by iMac on 16/8/30.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendScrollContentView : UIControl

@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, weak) UILabel *titleLabel;

@end


@interface RecommendScrollCell : UICollectionViewCell

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray *contentViews;

- (RecommendScrollContentView *)dequeueReusableContentViewforIndex:(NSUInteger)index;

@end
