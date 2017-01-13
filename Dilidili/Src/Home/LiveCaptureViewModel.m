//
//  LiveCaptureViewModel.m
//  Dilidili
//
//  Created by iMac on 2017/1/12.
//  Copyright © 2017年 BoxingWoo. All rights reserved.
//

#import "LiveCaptureViewModel.h"

@implementation LiveCaptureViewModel

- (instancetype)init
{
    if (self = [super init]) {
        // 填写你电脑的IP地址
        _rtmpUrl = @"rtmp://192.168.1.247:1935/rtmplive/room";
    }
    return self;
}

@end
