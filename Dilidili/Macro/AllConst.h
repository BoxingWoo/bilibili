//
//  AllConst.h
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#ifndef AllConst_h
#define AllConst_h

//iTunesURL
#define kAppiTunesURL = @"https://itunes.apple.com/cn/app/bi-li-bi-li-dong-hua-dan-mu/id736536022?mt=8";

//UserDefaults
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

//Log
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#define NSLog(...)
#endif

#endif /* AllConst_h */
