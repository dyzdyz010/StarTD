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

- (void)writeProperties;

@end

@implementation GameDataManager
@synthesize skillPoint = _skillPoint;

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
    _skillPoint = [_userDic valueForKey:SKILLPOINT];
    _settingsDic = [_infoDic objectForKey:SETTINGS];
    
    //NSLog(@"%@", _upgradesDic);
    //NSLog(@"%@", _userDic);
    //NSLog(@"%@", _settingsDic);
}

- (NSInteger)levelForSkill:(NSString *)name
{
    return [[_upgradesDic valueForKey:name] intValue];
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
    [self writeProperties];
    
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
    [self writeProperties];
    
    return nil;
}

- (NSDictionary *)missionByIndex:(NSInteger)index
{
    return [[[_infoDic objectForKey:MISSIONS] objectAtIndex:index] copy];
}

- (NSArray *)enemiesByRace:(NSString *)race
{
    return [[[_infoDic objectForKey:ENEMIES] objectForKey:race] copy];
}

- (NSArray *)towersByRace:(NSString *)race
{
    return [[[_infoDic objectForKey:TOWERS] objectForKey:race] copy];
}

- (NSDictionary *)settingsForCategory:(NSString *)category
{
    return [[_settingsDic objectForKey:category] copy];
}

- (void)updateSettings:(NSDictionary *)settings ForCategory:(NSString *)category
{
    [_settingsDic setValue:settings forKey:category];
    NSLog(@"%@", _settingsDic);
    [self writeProperties];
}


- (void)writeProperties
{
    [_infoDic writeToFile:dstPath atomically:YES];
}

@end
