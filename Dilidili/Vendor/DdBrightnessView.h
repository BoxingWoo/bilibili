//
//  DdBrightnessView.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/23.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DdBrightnessView : UIVisualEffectView

+ (instancetype)sharedBrightnessView;

+ (void)show;

+ (void)hide:(BOOL)animate;

@end
