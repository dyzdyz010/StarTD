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
#import "Enemy.h"

@interface Tower () {
    SceneManager *_manager;
    NSTimer *fireTimer;
    NSMutableArray *_firePositionArray;
}
- (id)initWithName:(NSString*)name race:(NSString *)race manager:(SceneManager *)manager towerIndex:(int)index;

- (void)generateFirePosition;
- (void)fire;

@end

@implementation Tower

@synthesize  attackRate = _attackRate,
            attackBound = _attackBound,
            attackSpeed = _attackSpeed,
                   cost = _cost,
               posIndex = _posIndex;

+ (id)towerByName:(NSString *)name race:(NSString *)race manager:(SceneManager *)manager towerIndex:(int)index
{
    return [[Tower alloc] initWithName:name race:race manager:manager towerIndex:index];
}

- (id)initWithName:(NSString *)name race:(NSString *)race manager:(SceneManager *)manager towerIndex:(int)index
{
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0.1", kNGLMeshKeyNormalize,
                              nil];
    
    NSString *meshName = [NSString stringWithFormat:@"%@.obj", name];
    self = [super initWithFile:meshName settings:settings delegate:self];
    if (self) {
        _posIndex = index;
        self.name = name;
        _manager = manager;
        _firePositionArray = [[NSMutableArray alloc] init];
        
        NSDictionary *towerDic = [[GameDataManager sharedManager] towerByName:name race:race];
        _attackRate = [[towerDic valueForKey:ATTACKRATE] floatValue];
        float unitDist = 1.0 / manager.mapWidth;
        //_attackBound = [[towerDic valueForKey:ATTACKBOUND] floatValue] * unitDist;
        _attackBound = 50 * unitDist;
        _attackSpeed = [[towerDic valueForKey:ATTACKSPEED] floatValue];
        _cost = [[towerDic valueForKey:COST] intValue];
        [self generateFirePosition];
        
        NSLog(@"Tower initialized, attack rate:%f, attack bound:%f, attack speed:%f", _attackRate, _attackBound, _attackSpeed);
        
        fireTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / _attackSpeed target:self selector:@selector(fire) userInfo:nil repeats:YES];
        
        NGLvec3 pos = [_manager towerPositionByIndex:index];
        self.x = pos.x; self.y = pos.y + 0.2; self.z = pos.z;
    }
    
    return self;
}

- (void)generateFirePosition
{
    for (int i = _manager.routeLength - 1; i >= 0; i--) {
        NGLvec3 target = [_manager routePositionByIndex:i];
        NGLvec3 dist = nglVec3Subtract(*self.position, target);
        if (nglVec3Length(dist) <= _attackBound) {
            [_firePositionArray addObject:[NSNumber numberWithInteger:i]];
            NSLog(@"Fire position found:%d", i);
        }
    }
}

- (void)fire
{
    for (NSNumber *num in _firePositionArray) {
        int i = [num intValue];
        Enemy *e = [_manager enemyOnPosition:i];
        if (e != nil) {
            e.health -= _attackRate;
            NSLog(@"Attack:%@", e.name);
        }
    }
}

@end
