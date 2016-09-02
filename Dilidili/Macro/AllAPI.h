//
//  AllAPI.h
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#ifndef AllAPI_h
#define AllAPI_h

#define DdServer_App @"http://app.bilibili.com"
#define DdServer_Api @"http://api.bilibili.com"
#define DdServer_Bilibili @"http://www.bilibili.com"
#define DdServer_Umeng @"http://oc.umeng.com"
#define DdServer_Bangumi @"http://bangumi.bilibili.com"

//推荐列表接口 http://app.bilibili.com/x/v2/show?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&sign=207007525573941d525bb02b501243d3&ts=1472090858&warm=0
#define DdRecommendListURL DdServer_App@"/x/v2/show"

//推荐列表热门刷新接口 http://app.bilibili.com/x/v2/show/change?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&rand=1&sign=d41a21ba1610b9f1c7acb0aa82d36500&ts=1472611516
#define DdRecommendHotRefreshURL DdServer_App@"/x/v2/show/change"

//推荐列表直播刷新接口 http://app.bilibili.com/x/show/live?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&rand=0&sign=52fdf0fbdfe33a3a0b2ac7e56a4c70ba&ts=1472611684
#define DdRecommendLiveRefreshURL DdServer_App@"/x/show/live"

//推荐列表刷新接口 http://www.bilibili.com/index/ding/1.json?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&device=phone&mobi_app=iphone&pagesize=20&platform=ios&sign=3d1f7b1364698b7123208f6c1b4257db&tid=1&ts=1472611797
#define DdRecommendRegionRefreshURL DdServer_Bilibili@"/index/ding"

#endif /* AllAPI_h */
