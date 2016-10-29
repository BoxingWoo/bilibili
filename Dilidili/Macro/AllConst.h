//
//  AllConst.h
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#ifndef AllConst_h
#define AllConst_h

//AppScheme
#define kAppScheme @"dilidili"

//iTunesURL
#define kAppiTunesURL = @"https://itunes.apple.com/cn/app/bi-li-bi-li-dong-hua-dan-mu/id736536022?mt=8";

//HostName
#define DdServer_App @"http://app.bilibili.com"
#define DdServer_Api @"http://api.bilibili.com"
#define DdServer_Bilibili @"http://www.bilibili.com"
#define DdServer_Danmaku @"http://comment.bilibili.com"
#define DdServer_live @"http://live.bilibili.com"
#define DdServer_Bangumi @"http://bangumi.bilibili.com"
#define DdServer_Umeng @"http://oc.umeng.com"

//UserDefaults
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
//弱引用
#define WeakSelf __weak typeof(self) weakSelf = self

//Log
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#define NSLog(...)
#endif

#endif /* AllConst_h */
