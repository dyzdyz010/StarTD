//
//  SceneManager.m
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/15/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import "SceneManager.h"
#import "Enemy.h"
#import "Tower.h"
#import "GameDataManager.h"

#define BASEHEALTH 1000

@interface SceneManager () {
    Vertex *_vertics;
    int *_routeIndex;
    NSArray *_enemiesInfoArray;
    NSMutableArray *_enemiesArray;
    NSMutableArray *_towersArray;
    NSString *_race;
    
    BOOL _pause;
    BOOL _newWave;
    int _currentWave;
    int _baseHealth;
}
- (id)initWithMap:(Map *)map camera:(NGLCamera *)camara race:(NSString *)race;
- (void)addBase:(NSString *)race;

- (void)beginWave;
- (void)addEnemy:(NSDictionary *)infoDic;

- (void)updateEnemyPosition;
- (void)updateTowerEffect;

@end

@implementation SceneManager

@synthesize routeLength = _routeLength,
               mapWidth = _mapWidth,
          twPositionSet = _twPositionSet,
                 status = _status,
                  money = _money,
                 camera = _camera;

+ (id)managerForMap:(Map *)map camera:(NGLCamera *)camara race:(NSString *)race
{
    return [[SceneManager alloc] initWithMap:map camera:(NGLCamera *)camara race:race];
}

- (id)initWithMap:(Map *)map camera:(NGLCamera *)camara race:(NSString *)race
{
    self = [super init];
    if (self) {
        _vertics = map.vertics;
        _routeLength = map.routeLength;
        _routeIndex = map.route;
        _camera = camara;
        _race = race;
        
        _enemiesInfoArray = [[GameDataManager sharedManager] enemies];
        _enemiesArray = [[NSMutableArray alloc] init];
        _towersArray = [[NSMutableArray alloc] init];
        
        _money = 200;
        _currentWave = 0;
        _pause = NO;
        _newWave = NO;
        _status = InProcess;
        _mapWidth = map.width;
        _twPositionSet = map.twPositionSet;
        
        [self addBase:race];
    }
    
    return self;
}

- (void)addBase:(NSString *)race
{
    _baseHealth = BASEHEALTH;
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0.3", kNGLMeshKeyNormalize,
                              nil];
    NSString *baseName = [NSString stringWithFormat:@"%@.obj", [[[GameDataManager sharedManager] baseByRace:race] valueForKey:NAME]];
    NSLog(@"Base name: %@", baseName);
    NGLMesh *base = [[NGLMesh alloc] initWithFile:baseName settings:settings delegate:nil];
    NGLvec3 basePos = _vertics[_routeIndex[_routeLength-1]].position;
    base.x = basePos.x; base.y = basePos.y; base.z = basePos.z;
    [_camera addMesh:base];
}

- (void)addTowerByName:(NSString *)name position:(int)index cost:(int)cost
{
    Tower *tower = [Tower towerByName:name race:_race manager:self towerIndex:index];
    [_camera addMesh:tower];
    [_towersArray addObject:tower];
    _money -= cost;
}

- (void)gamePause
{
    _pause = YES;
}

- (void)beginWave
{
    if (_currentWave == [_enemiesInfoArray count]) {
        _status = Win;
        return;
    }
    _newWave = YES;
    [self performSelectorInBackground:@selector(addEnemy:) withObject:[_enemiesInfoArray objectAtIndex:_currentWave]];
}

- (void)addEnemy:(NSDictionary *)infoDic
{
    sleep(1);
    
    for (int i = 0; i < [[infoDic valueForKey:AMOUNT] intValue]; i++) {
        Enemy *e = [Enemy enemyByName:[infoDic valueForKey:NAME] routeLength:_routeLength mapWidth:_mapWidth manager:self];
        *e.position = (NGLvec3){
            _vertics[_routeIndex[0]].position.x,
            _vertics[_routeIndex[0]].position.y,
            _vertics[_routeIndex[0]].position.z
        };
        //printf("Init location:(%f, %f, %f)\n", _vertics[_routeIndex[0]].position.x, _vertics[_routeIndex[0]].position.y, _vertics[_routeIndex[0]].position.z);
        [_enemiesArray addObject:e];
        [_camera addMesh:e];
        [e initDirection:(NGLvec3){1.0, 0.0, 0.0}];
        _newWave = NO;
        
        sleep(5);
    }
}

- (void)render
{
    if (_pause || _status != InProcess) {
        return;
    }
    
    [self updateEnemyPosition];
    [self updateTowerEffect];
}

- (void)updateEnemyPosition
{
    if ([_enemiesArray count] == 0) {
        if (_newWave) {
            return;
        } else {
            [self beginWave];
            _currentWave += 1;
        }
    }
    for (int i = 0; i < [_enemiesArray count]; i++) {
        Enemy *e = [_enemiesArray objectAtIndex:i];
        if (e.finished) {
            //NSLog(@"One tank finished.");
            _baseHealth -= e.health;
            NSLog(@"Base health: %d", _baseHealth);
            [_enemiesArray removeObject:e];
            [_camera removeMesh:e];
            
            if (_baseHealth <= 0) {
                _status = Lose;
                NSLog(@"Game Lose!");
                return;
            }
            
            continue;
        }
        [e render:_vertics[_routeIndex[e.posIndex]].position forRotate:_vertics[_routeIndex[e.posIndex+1]].position];
        //printf("Tank pos: (%f, %f, %f)\n", e.x, e.y, e.z);
    }
}

- (void)updateTowerEffect
{
    for (Tower *t in _towersArray) {
        [t render];
    }
}

- (NGLvec3)routePositionByIndex:(int)index
{
    return _vertics[_routeIndex[index]].position;
}

- (NGLvec3)towerPositionByIndex:(int)index
{
    _twPositionSet[index].isBuild = YES;
    return _twPositionSet[index].position_3D;
}

- (Enemy *)enemyOnPosition:(int)index
{
    for (Enemy *e in _enemiesArray) {
        if (e.posIndex == index) {
            return e;
        }
    }
    
    return nil;
}

@end
