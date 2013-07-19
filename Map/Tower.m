//
//  Tower.m
//  GameSceneTest
//
//  Created by 杜 艺卓 on 7/12/13.
//
//

#import "Tower.h"
#import "GameDataManager.h"
#import "SceneManager.h"

@interface Tower () {
    SceneManager *_manager;
    
    NSMutableArray *_firePosition;
}
- (id)initWithName:(NSString*)name race:(NSString *)race manager:(SceneManager *)manager;

- (void)generateFirePosition;

@end

@implementation Tower

@synthesize attackRate = _attackRate, attackBound = _attackBound, attackSpeed = _attackSpeed, cost = _cost;

+ (id)towerByName:(NSString *)name race:(NSString *)race manager:(SceneManager *)manager
{
    return [[Tower alloc] initWithName:name race:race manager:manager];
}

- (id)initWithName:(NSString *)name race:(NSString *)race manager:(SceneManager *)manager
{
    NSString *meshName = [NSString stringWithFormat:@"%@.obj", name];
    self = [super initWithFile:meshName settings:nil delegate:self];
    if (self) {
        self.name = name;
        _manager = manager;
        _firePosition = [[NSMutableArray alloc] init];
        
        NSDictionary *towerDic = [[GameDataManager sharedManager] towerByName:name race:race];
        _attackRate = [[towerDic valueForKey:ATTACKRATE] floatValue];
        float unitDist = 1.0 / manager.mapWidth;
        _attackBound = [[towerDic valueForKey:ATTACKBOUND] floatValue] * unitDist;
        _attackSpeed = [[towerDic valueForKey:ATTACKSPEED] floatValue];
        _cost = [[towerDic valueForKey:COST] intValue];
    }
    
    return self;
}

- (void)generateFirePosition

@end
