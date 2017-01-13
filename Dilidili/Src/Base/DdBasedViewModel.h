//
//  DdBasedViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/5.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DdBasedViewModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic, copy) NSString *className;
@property(nonatomic, copy) NSURL *URL;
@property (nonatomic, copy) NSDictionary *params;

- (instancetype)initWithClassName:(NSString *)className params:(NSDictionary *)params;

@end
