//
//  LiveCaptureViewModel.h
//  Dilidili
//
//  Created by iMac on 2017/1/12.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "DdBasedViewModel.h"

/**
 直播推流视图模型
 */
@interface LiveCaptureViewModel : DdBasedViewModel

/** 推流URL */
@property (nonatomic, copy) NSString *rtmpUrl;

@end
