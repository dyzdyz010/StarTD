//
//  GameDataManager.m
//  GameDataManager
//
//  Created by 杜 艺卓 on 7/7/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import "GameDataManager.h"

@interface GameDataManager () {
    NSDictionary *_upgradesDic;
    NSDictionary *_userDic;
    NSDictionary *_settingsDic;
}
- (void)loadProperties;

@end

@implementation GameDataManager
static GameDataManager *instance;

+ (GameDataManager *)sharedManager
{
    @synchronized(self) {
        if (!instance) {
            instance = [[super allocWithZone:NULL] init];
        }
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *ori = [[NSBundle mainBundle] pathForResource:@"gameData" ofType:@"plist"];
        dstPath = [NSString stringWithFormat:@"%@/Documents/gameData.plist", NSHomeDirectory()];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dstPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:ori toPath:dstPath error:nil];
        }
        _infoDic = [NSMutableDictionary dictionaryWithContentsOfFile:dstPath];
        [self loadProperties];
    }
    
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return  self;
}

- (void)loadProperties
{
    _upgradesDic = [_infoDic objectForKey:UPGRADES];
    _userDic = [_infoDic objectForKey:USER];
    _settingsDic = [_infoDic objectForKey:SETTINGS];
    NSLog(@"%@", _upgradesDic);
    NSLog(@"%@", _userDic);
    NSLog(@"%@", _settingsDic);
}

- (NSError *)upgrade:(NSString *)name
{
    UpgradeError err;
    int level = [[_upgradesDic valueForKey:name] intValue];
    if (level == UPGRADELEVELMAX) {
        err = UELevelMax;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"已经满级，不能再升级。"
                                                             forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:@"com.error" code:err userInfo:userInfo];
    }
    
    [_upgradesDic setValue:[NSNumber numberWithInt:level + 1] forKey:name];
    
    return nil;
}

- (NSError *)downgrade:(NSString *)name
{
    UpgradeError err;
    int level = [[_upgradesDic valueForKey:name] intValue];
    if (level == UPGRADELEVELMIN) {
        err = UELevelMin;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"技能等级已经最低，不能再降级。"
                                                             forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:@"com.error" code:err userInfo:userInfo];
    }
    
    [_upgradesDic setValue:[NSNumber numberWithInt:level - 1] forKey:name];
    
    return nil;
}

@end
