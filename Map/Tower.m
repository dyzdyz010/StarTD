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

#import "SingerBullet.h"
#import "AudioManager.h"

@interface Tower () {
    SceneManager *_manager;
    NSTimer *fireTimer;
    NSMutableArray *_firePositionArray;
    
    SingerBullet *_bullet;
    
    BOOL _attacking;
    float _bulletMoveTime;
    int _bulletCurrentTime;
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
        _bullet = [[SingerBullet alloc] init];
        //[manager.camera addMeshesFromArray:[_bullet GetSmokeArray]];
        _attacking = NO;
        _bulletMoveTime = 0.0;
        _bulletCurrentTime = 0;
        
        NSDictionary *towerDic = [[GameDataManager sharedManager] towerByName:name race:race];
        _attackRate = [[towerDic valueForKey:ATTACKRATE] floatValue];
        float unitDist = 1.0 / manager.mapWidth;
        _attackBound = [[towerDic valueForKey:ATTACKBOUND] floatValue] * unitDist;
        //_attackBound = 50 * unitDist;
        _attackSpeed = [[towerDic valueForKey:ATTACKSPEED] floatValue];
        _cost = [[towerDic valueForKey:COST] intValue];
        
        NSLog(@"Tower initialized, attack rate:%f, attack bound:%f, attack speed:%f", _attackRate, _attackBound, _attackSpeed);
        
        NGLvec3 pos = [_manager towerPositionByIndex:index];
        self.x = pos.x; self.y = pos.y; self.z = pos.z;
        [self generateFirePosition];
        fireTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / _attackSpeed target:self selector:@selector(fire) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)generateFirePosition
{
    for (int i = _manager.routeLength - 1; i >= 0; i--) {
        NGLvec3 target = [_manager routePositionByIndex:i];
        NGLvec3 selfPos = (NGLvec3){
            self.x,
            self.y,
            self.z
        };
        NGLvec3 dist = nglVec3Subtract(selfPos, target);
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
        NSLog(@"i = %d", i);
        Enemy *e = [_manager enemyOnPosition:i];
        if (e != nil) {
            e.health -= _attackRate;
            [[AudioManager sharedManager] playsoundTuttet];
            NSLog(@"Attack:%@", e.name);
            NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"1.0", kNGLMeshKeyNormalize,
                                      nil];
            NGLvec3 startPos = (NGLvec3){
                self.x,
                self.y,
                self.z
            };
            NGLvec3 endPos = (NGLvec3){
                e.x,
                e.y,
                e.z
            };
            if(_attacking == NO){
                [_bullet InitBulletType:RED_SMALL_BULLET StarPos:startPos EndPos:endPos Setting:settings];
                _bulletMoveTime = [_bullet GetBulletMovetime];
                NSLog(@"Bullet total move time: %f", _bulletMoveTime);
                [_manager.camera addMesh:[_bullet GetMesh]];
                _attacking = YES;
            }
        }
    }
}

- (void)render
{
    if (_attacking) {
        if (_bulletCurrentTime < _bulletMoveTime) {
            [_bullet MoveBullet:_bulletCurrentTime];
            _bulletCurrentTime += 1;
            NSLog(@"Bullet current time: %d", _bulletCurrentTime);
            
        } else {
            _attacking = NO;
            _bulletCurrentTime = 1;
            [_manager.camera removeMesh:[_bullet GetMesh]];
        }
        
       
        NSLog(@"Tower render.");
    }
}

@end
