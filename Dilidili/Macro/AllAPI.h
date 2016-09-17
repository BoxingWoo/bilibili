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
#define DdServer_Danmaku @"http://comment.bilibili.com"
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

//视频简介接口 http://app.bilibili.com/x/v2/view?actionKey=appkey&aid=6206361&appkey=27eb53fc9058f8c3&build=3710&device=phone&from=6&mobi_app=iphone&platform=ios&sign=ef348e588eea0d3a1bb336450abd9d57&ts=1473735123
#define DdVideoInfoURL DdServer_App@"/x/v2/view"

//视频评论接口 http://api.bilibili.com/x/reply?_device=iphone&_hwid=2e771212f4b4dc67&_ulv=0&access_key=&appkey=27eb53fc9058f8c3&appver=3710&build=3710&oid=6206361&platform=ios&pn=1&ps=20&sign=fd4c5da7003bf1ea7a62165b4e68cb73&sort=0&type=1
#define DdVideoReplyURL DdServer_Api@"/x/reply"

//获取视频播放链接接口(html5) http://www.bilibili.com/m/html5?aid=6011162&page=1
#define DdVideoPathURL DdServer_Bilibili@"/m/html5"

//视频弹幕接口 http://comment.bilibili.com/10080432.xml
#define DdVideoDanmakuURL DdServer_Danmaku

#endif /* AllAPI_h */
