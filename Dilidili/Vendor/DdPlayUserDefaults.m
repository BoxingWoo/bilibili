//
//  DdPlayUserDefaults.m
//  Dilidili
//
//  Created by iMac on 2016/12/28.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdPlayUserDefaults.h"

@interface DdPlayUserDefaults ()

@property (nonatomic, strong) YYKVStorage *playStorage;

@end

@implementation DdPlayUserDefaults

#pragma mark 单例方法
+ (instancetype)sharedInstance
{
    static DdPlayUserDefaults *playUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playUserDefaults = [[self alloc] _init];
    });
    return playUserDefaults;
}

- (instancetype)_init
{
    if (self = [super init]) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"BoxingWoo.Dilidili.Storages/PlayUserDefaults"];
        _playStorage = [[YYKVStorage alloc] initWithPath:path type:YYKVStorageTypeSQLite];
        
        if ([self.playStorage itemExistsForKey:@"activeBackgroundPlayback"]) {
            _activeBackgroundPlayback = [[NSKeyedUnarchiver unarchiveObjectWithData:[self.playStorage getItemValueForKey:@"activeBackgroundPlayback"]] boolValue];
        }else {
            self.activeBackgroundPlayback = NO;
        }
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[DdPlayUserDefaults sharedInstance]" userInfo:nil];
    return nil;
}

#pragma mark - Setter

- (void)setActiveBackgroundPlayback:(BOOL)activeBackgroundPlayback
{
    if (_activeBackgroundPlayback != activeBackgroundPlayback) {
        _activeBackgroundPlayback = activeBackgroundPlayback;
        [self.playStorage saveItemWithKey:@"activeBackgroundPlayback" value:[NSKeyedArchiver archivedDataWithRootObject:@(_activeBackgroundPlayback)]];
    }
}

@end
