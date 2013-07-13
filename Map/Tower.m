//
//  Tower.m
//  GameSceneTest
//
//  Created by 杜 艺卓 on 7/12/13.
//
//

#import "Tower.h"
#import "GameDataManager.h"

@interface Tower ()
- (id)initWithName:(NSString*)name race:(NSString *)race;

@end

@implementation Tower

@synthesize attackRate = _attackRate, attackBound = _attackBound, attackSpeed = _attackSpeed, cost = _cost;

+ (id)towerByName:(NSString *)name race:(NSString *)race
{
    return [[Tower alloc] initWithName:name race:race];
}

- (id)initWithName:(NSString *)name race:(NSString *)race
{
    NSString *meshName = [NSString stringWithFormat:@"%@.obj", name];
    self = [super initWithFile:meshName settings:nil delegate:self];
    if (self) {
        self.name = name;
        NSDictionary *towerDic = [[GameDataManager sharedManager] towerByName:name race:race];
        _attackRate = [[towerDic valueForKey:ATTACKRATE] floatValue];
        _attackBound = [[towerDic valueForKey:ATTACKBOUND] floatValue];
        _attackSpeed = [[towerDic valueForKey:ATTACKSPEED] floatValue];
        _cost = [[towerDic valueForKey:COST] intValue];
    }
    
    return self;
}

@end
