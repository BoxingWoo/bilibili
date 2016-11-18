//
// Created by Shaokang Zhao on 15/1/12.
// Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTag.h"

@implementation SKTag

- (instancetype)init
{
    if (self = [super init]) {
        _bgColor = [UIColor whiteColor];
        _enable = YES;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
{
    self = [self init];
    if (self)
    {
        _text = text;
        _fontSize = 14;
        _textColor = [UIColor colorWithWhite:45 / 255.0 alpha:1.0];
    }
    
    return self;
}

+ (instancetype)tagWithText:(NSString *)text
{
    return [[self alloc] initWithText:text];
}

@end