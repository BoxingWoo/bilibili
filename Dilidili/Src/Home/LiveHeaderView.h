//
//  LiveHeaderView.h
//  Dilidili
//
//  Created by BoxingWoo on 16/10/5.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLoopScrollView.h"

@interface LiveHeaderView : UICollectionReusableView

@property (nonatomic, weak) BSLoopScrollView *loopScrollView;
@property (nonatomic, strong) RACSubject *actionSubject;

@end
