//
//  LiveHotWordModel.h
//  Dilidili
//
//  Created by iMac on 2016/10/24.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 直播热门关键字模型
 */
@interface LiveHotWordModel : NSObject

/**
 ID
 */
@property (nonatomic, assign) NSInteger hot_word_id;
/**
 关键词
 */
@property (nonatomic, copy) NSString *words;

@end
