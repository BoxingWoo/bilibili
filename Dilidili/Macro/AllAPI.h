//
//  AllAPI.h
//  Dilidili
//
//  Created by iMac on 16/8/23.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#ifndef AllAPI_h
#define AllAPI_h

// 推荐列表接口 http://app.bilibili.com/x/v2/show?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&sign=207007525573941d525bb02b501243d3&ts=1472090858&warm=0
#define DdRecommendListURL DdServer_App@"/x/v2/show"

// 推荐列表热门刷新接口 http://app.bilibili.com/x/v2/show/change?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&rand=1&sign=d41a21ba1610b9f1c7acb0aa82d36500&ts=1472611516
#define DdRecommendHotRefreshURL DdServer_App@"/x/v2/show/change"

// 推荐列表直播刷新接口 http://app.bilibili.com/x/show/live?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&channel=appstore&device=phone&mobi_app=iphone&plat=1&platform=ios&rand=0&sign=52fdf0fbdfe33a3a0b2ac7e56a4c70ba&ts=1472611684
#define DdRecommendLiveRefreshURL DdServer_App@"/x/show/live"

// 推荐列表刷新接口 http://www.bilibili.com/index/ding/1.json?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3600&device=phone&mobi_app=iphone&pagesize=20&platform=ios&sign=3d1f7b1364698b7123208f6c1b4257db&tid=1&ts=1472611797
#define DdRecommendRegionRefreshURL DdServer_Bilibili@"/index/ding"

// 视频简介接口 http://app.bilibili.com/x/v2/view?actionKey=appkey&aid=6206361&appkey=27eb53fc9058f8c3&build=3710&device=phone&from=6&mobi_app=iphone&platform=ios&sign=ef348e588eea0d3a1bb336450abd9d57&ts=1473735123
#define DdVideoInfoURL DdServer_App@"/x/v2/view"

// 视频评论接口 http://api.bilibili.com/x/reply?_device=iphone&_hwid=2e771212f4b4dc67&_ulv=0&access_key=&appkey=27eb53fc9058f8c3&appver=3710&build=3710&oid=6206361&platform=ios&pn=1&ps=20&sign=fd4c5da7003bf1ea7a62165b4e68cb73&sort=0&type=1
#define DdVideoReplyURL DdServer_Api@"/x/reply"

// 获取视频播放链接接口(html5) http://api.bilibili.com/playurl?callback=jQuery17209494781185433222_1479709396179&aid=7154415&page=1&platform=html5&quality=1&vtype=mp4&type=jsonp&token=d41d8cd98f00b204e9800998ecf8427e&_=1479709396573
#define DdVideoPathURL DdServer_Api@"/playurl"

// 弹幕接口 http://comment.bilibili.com/10080432.xml
#define DdDanmakuURL DdServer_Danmaku

// 直播列表推荐接口 http://live.bilibili.com/AppNewIndex/recommend?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3870&buvid=E25A38CE-0436-44C9-AC81-7D82A7CDA6985936infoc&device=phone&mobi_app=iphone&platform=ios&scale=2&sign=62a5dd5d2012b839dfde09f6eee471d7&ts=1475576150
#define DdLiveRecommendURL DdServer_live@"/AppNewIndex/recommend"

// 直播列表接口 http://live.bilibili.com/AppNewIndex/common?scale=2&device=phone&platform=ios
#define DdLiveListURL DdServer_live@"/AppNewIndex/common"

// 直播列表推荐刷新接口 http://live.bilibili.com/AppIndex/recommendRefresh?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3870&device=phone&mobi_app=iphone&platform=ios&sign=39e3b557397f1026ddb239731c213004&ts=1475576802
#define DdLiveRecommendRefreshURL DdServer_live@"/AppIndex/recommendRefresh"

// 直播列表刷新接口 http://live.bilibili.com/AppIndex/dynamic?actionKey=appkey&appkey=27eb53fc9058f8c3&area=draw&build=3870&device=phone&mobi_app=iphone&platform=ios&sign=4b9e74f5855c99526b53bd4302df8d8c&ts=1475576931
#define DdLiveRefreshURL DdServer_live@"/AppIndex/dynamic"

// 全部直播接口（最热：sort=hottest，最新：sort=latest） http://live.bilibili.com/mobile/rooms?actionKey=appkey&appkey=27eb53fc9058f8c3&area_id=0&build=3870&device=phone&mobi_app=iphone&page=1&platform=ios&sign=3ef31cf1ae047a52691d2fa7bc43b778&sort=hottest&ts=1475577110
#define DdLiveAllURL DdServer_live@"/mobile/rooms"

// 直播信息接口 http://live.bilibili.com/AppRoom/index?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3940&buvid=E25A38CE-0436-44C9-AC81-7D82A7CDA6985936infoc&device=phone&jumpFrom=24000&mobi_app=iphone&platform=ios&room_id=335045&scale=2&sign=069e8c1f182d0978a4cceb1c9e4424e0&ts=1477277752
#define DdLiveInfoURL DdServer_live@"/AppRoom/index"

// 番剧索引接口 http://bangumi.bilibili.com/api/app_index_page_v4?build=3970&device=phone&mobi_app=iphone&platform=ios
#define DdBangumiIndexURL DdServer_Bangumi@"/api/app_index_page_v4"

// 番剧推荐接口 http://bangumi.bilibili.com/api/bangumi_recommend?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&cursor=0&device=phone&mobi_app=iphone&pagesize=10&platform=ios&sign=6b92b97e3ef0d32c88c36cd18a76dc4b&ts=1478922819
#define DdBangumiRecommendURL DdServer_Bangumi@"/api/bangumi_recommend"

#endif /* AllAPI_h */
