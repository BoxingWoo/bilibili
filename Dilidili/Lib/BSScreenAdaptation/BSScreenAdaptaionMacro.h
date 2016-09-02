//
//  BSScreenAdaptaionMacro.h
//
//  Created by mac on 16/7/30.
//  Copyright (c) 2016年 BoxingWoo. All rights reserved.
//

#ifndef BSScreenAdaptaionMacro_h
#define BSScreenAdaptaionMacro_h

#define AdaptaionFlag

#ifdef AdaptaionFlag
    #define CGRectMake CGRectMakeEx
    #define CGSizeMake CGSizeMakeEx
    #define CGPointMake CGPointMakeEx
    #define widthEx widthEx
    #define heightEx heightEx
#else
    #define CGRectMake CGRectMake
    #define CGSizeMake CGSizeMake
    #define CGPointMake CGPointMake
    #define widthEx
    #define heightEx
#endif

#endif
