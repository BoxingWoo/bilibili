//
//  DdDanmakuUserDefaults.m
//  Dilidili
//
//  Created by iMac on 2016/9/26.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdDanmakuUserDefaults.h"
#import <BarrageRenderer/BarrageRenderer.h>

@interface DdDanmakuUserDefaults ()

@property (nonatomic, strong) YYKVStorage *danmakuStorage;

@end

@implementation DdDanmakuUserDefaults

#pragma mark 单例方法
+ (instancetype)sharedInstance
{
    static DdDanmakuUserDefaults *danmakuUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        danmakuUserDefaults = [[self alloc] _init];
    });
    return danmakuUserDefaults;
}

- (instancetype)_init
{
    if (self = [super init]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"BoxingWoo.Dilidili.Storages/DanmakuUserDefaults"];
        _danmakuStorage = [[YYKVStorage alloc] initWithPath:path type:YYKVStorageTypeSQLite];
        
        if ([self.danmakuStorage itemExistsForKey:@"shieldingOption"]) {
            _shieldingOption = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.danmakuStorage getItemValueForKey:@"shieldingOption"]] integerValue];
        }else {
            self.shieldingOption = DdDanmakuShieldingNone;
        }
        
        if ([self.danmakuStorage itemExistsForKey:@"screenMaxlimit"]) {
            _screenMaxlimit = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.danmakuStorage getItemValueForKey:@"screenMaxlimit"]] unsignedIntegerValue];
        }else {
            self.screenMaxlimit = 30;
        }
        
        if ([self.danmakuStorage itemExistsForKey:@"speed"]) {
            _speed = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.danmakuStorage getItemValueForKey:@"speed"]] doubleValue];
        }else {
            self.speed = 7.5;
        }
        
        if ([self.danmakuStorage itemExistsForKey:@"opacity"]) {
            _opacity = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.danmakuStorage getItemValueForKey:@"opacity"]] doubleValue];
        }else {
            self.opacity = 0.8;
        }
        
        if ([self.danmakuStorage itemExistsForKey:@"preferredFontSize"]) {
            _preferredFontSize = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.danmakuStorage getItemValueForKey:@"preferredFontSize"]] integerValue];
        }else {
            self.preferredFontSize = DdDanmakuFontSizeNormal;
        }
        
        if ([self.danmakuStorage itemExistsForKey:@"preferredStyle"]) {
            _preferredStyle = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.danmakuStorage getItemValueForKey:@"preferredStyle"]] integerValue];
        }else {
            self.preferredStyle = DdDanmakuWalkR2L;
        }
        
        if ([self.danmakuStorage itemExistsForKey:@"preferredTextColorValue"]) {
            self.preferredTextColorValue = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.danmakuStorage getItemValueForKey:@"preferredTextColorValue"]] integerValue];
        }else {
            self.preferredTextColorValue = DdDanmakuWhite;
        }
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[DdDanmakuUserDefaults sharedInstance]" userInfo:nil];
    return nil;
}

#pragma mark - Setter

- (void)setShieldingOption:(DdDanmakuShieldingOption)shieldingOption
{
    if (_shieldingOption != shieldingOption) {
        _shieldingOption = shieldingOption;
        [self.danmakuStorage saveItemWithKey:@"shieldingOption" value:[NSKeyedArchiver archivedDataWithRootObject:@(_shieldingOption)]];
    }
}

- (void)setScreenMaxlimit:(NSUInteger)screenMaxlimit
{
    if (_screenMaxlimit != screenMaxlimit) {
        _screenMaxlimit = screenMaxlimit;
        [self.danmakuStorage saveItemWithKey:@"screenMaxlimit" value:[NSKeyedArchiver archivedDataWithRootObject:@(_screenMaxlimit)]];
    }
}

- (void)setSpeed:(CGFloat)speed
{
    if (_speed != speed) {
        _speed = speed;
        [self.danmakuStorage saveItemWithKey:@"speed" value:[NSKeyedArchiver archivedDataWithRootObject:@(_speed)]];
    }
}

- (void)setOpacity:(CGFloat)opacity
{
    if (_opacity != opacity) {
        _opacity = opacity;
        [self.danmakuStorage saveItemWithKey:@"opacity" value:[NSKeyedArchiver archivedDataWithRootObject:@(_opacity)]];
    }
}

- (void)setPreferredFontSize:(DdDanmakuFontSize)preferredFontSize
{
    if (_preferredFontSize != preferredFontSize) {
        _preferredFontSize = preferredFontSize;
        [self.danmakuStorage saveItemWithKey:@"preferredFontSize" value:[NSKeyedArchiver archivedDataWithRootObject:@(_preferredFontSize)]];
    }
}

- (void)setPreferredStyle:(DdDanmakuStyle)preferredStyle
{
    if (_preferredStyle != preferredStyle) {
        _preferredStyle = preferredStyle;
        [self.danmakuStorage saveItemWithKey:@"preferredStyle" value:[NSKeyedArchiver archivedDataWithRootObject:@(_preferredStyle)]];
    }
}

- (void)setPreferredTextColorValue:(DdDanmakuColor)preferredTextColorValue
{
    if (_preferredTextColorValue != preferredTextColorValue) {
        _preferredTextColorValue = preferredTextColorValue;
        [self.danmakuStorage saveItemWithKey:@"preferredTextColorValue" value:[NSKeyedArchiver archivedDataWithRootObject:@(_preferredTextColorValue)]];
        
        CGFloat colorAlpha = self.opacity;
        switch (_preferredTextColorValue) {
            case DdDanmakuRed:
                _preferredTextColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:colorAlpha];
                break;
            case DdDanmakuBule:
                _preferredTextColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:colorAlpha];
                break;
            case DdDanmakuCyan:
                _preferredTextColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:colorAlpha];
                break;
            case DdDanmakuGreen:
                _preferredTextColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:colorAlpha];
                break;
            case DdDanmakuPurple:
                _preferredTextColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:colorAlpha];
                break;
            case DdDanmakuYellow:
                _preferredTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:colorAlpha];
                break;
            case DdDanmakuMagenta:
                _preferredTextColor = [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:colorAlpha];
                break;
            case DdDanmakuWhite:
                _preferredTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:colorAlpha];
                break;
            default:
                _preferredTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:colorAlpha];
                break;
        }
    }
}

#pragma mark 弹幕描述模型实例
- (BarrageDescriptor *)preferredDanmakuDescriptorWithText:(NSString *)text
{
    BarrageDescriptor *descriptor = [[BarrageDescriptor alloc] init];
    if (self.preferredStyle == DdDanmakuWalkR2L || self.preferredStyle == DdDanmakuWalkL2R) {
        descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
        NSNumber *direction = nil;
        switch (self.preferredStyle) {
            case DdDanmakuWalkR2L:
                direction = @(BarrageWalkDirectionR2L);
                break;
            case DdDanmakuWalkL2R:
                direction = @(BarrageWalkDirectionL2R);
                break;
            default:
                break;
        }
        descriptor.params[@"direction"] = direction;
        descriptor.params[@"side"] = @(BarrageWalkSideDefault);
        descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX + 50);
    }else {
        descriptor.spriteName = NSStringFromClass([BarrageFloatTextSprite class]);
        NSNumber *direction = nil;
        switch (self.preferredStyle) {
            case DdDanmakuFloatTop:
                direction = @(BarrageFloatDirectionT2B);
                break;
            case DdDanmakuFloatBottom:
                direction = @(BarrageFloatDirectionB2T);
                break;
            default:
                direction = @(BarrageFloatDirectionT2B);
                break;
        }
        descriptor.params[@"direction"] = direction;
        descriptor.params[@"side"] = @(BarrageFloatSideCenter);
        descriptor.params[@"duration"] = @(5.0);
    }
    
    CGFloat fontSize = 0;
    switch (self.preferredFontSize) {
        case DdDanmakuFontSizeNormal:
            fontSize = 17;
            break;
        case DdDanmakuFontSizeSmall:
            fontSize = 14;
            break;
        default:
            fontSize = 17;
            break;
    }
    descriptor.params[@"fontSize"] = @(fontSize);
    descriptor.params[@"textColor"] = _preferredTextColor;
    descriptor.params[@"text"] = text;
    descriptor.params[@"borderWidth"] = @(1.0);
    descriptor.params[@"borderColor"] = _preferredTextColor;
    
    return descriptor;
}

@end
