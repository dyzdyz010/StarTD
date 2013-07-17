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

@interface SceneManager () {
    NGLCamera *_camera;
    Vertex *_vertics;
    int *_routeIndex;
    NSArray *_enemiesInfoArray;
    NSMutableArray *_enemiesArray;
    NSMutableArray *_towersArray;
    
    BOOL _pause;
    BOOL _newWave;
    int _currentWave;
    int _mapWidth;
}
- (id)initWithMap:(Map *)map camera:(NGLCamera *)camara;

- (void)beginWave;
- (void)addEnemy:(NSDictionary *)infoDic;

- (void)updateEnemyPosition;

@end

@implementation SceneManager

@synthesize routeLength = _routeLength;

+ (id)managerForMap:(Map *)map camera:(NGLCamera *)camara
{
    return [[SceneManager alloc] initWithMap:map camera:(NGLCamera *)camara];
}

- (id)initWithMap:(Map *)map camera:(NGLCamera *)camara
{
    self = [super init];
    if (self) {
        _vertics = map.vertics;
        _routeLength = map.routeLength;
        _routeIndex = map.route;
        _camera = camara;
        
        _enemiesInfoArray = [[GameDataManager sharedManager] enemies];
        _enemiesArray = [[NSMutableArray alloc] init];
        _towersArray = [[NSMutableArray alloc] init];
        
        _currentWave = 0;
        _pause = NO;
        _newWave = NO;
        _mapWidth = map.width;
        
//        Enemy *e = [Enemy enemyByName:@"Tank" routeLength:_routeLength mapWidth:map.width];
//        *e.position = (NGLvec3){
//            _vertics[_routeIndex[0]].position.x,
//            _vertics[_routeIndex[0]].position.y,
//            _vertics[_routeIndex[0]].position.z
//        };
//        printf("Init location:(%f, %f, %f)\n", _vertics[_routeIndex[0]].position.x, _vertics[_routeIndex[0]].position.y, _vertics[_routeIndex[0]].position.z);
//        [_enemiesArray addObject:e];
//        [_camera addMesh:e];
//        
//        for (int i = 0; i < _routeLength; i++) {
//            printf("Waypoint: (%f, %f, %f)\n", _vertics[_routeIndex[i]].position.x, _vertics[_routeIndex[i]].position.y, _vertics[_routeIndex[i]].position.z);
//        }
        
    }
    
    return self;
}

- (void)addTower:(Tower *)tower
{
    [_towersArray addObject:tower];
    [_camera addMesh:tower];
}

- (void)gamePause
{
    _pause = YES;
}

- (void)beginWave
{
    _newWave = YES;
    [self performSelectorInBackground:@selector(addEnemy:) withObject:[_enemiesInfoArray objectAtIndex:_currentWave]];
}

- (void)addEnemy:(NSDictionary *)infoDic
{
    sleep(10);
    
    for (int i = 0; i < [[infoDic valueForKey:AMOUNT] intValue]; i++) {
        Enemy *e = [Enemy enemyByName:[infoDic valueForKey:NAME] routeLength:_routeLength mapWidth:_mapWidth];
        *e.position = (NGLvec3){
            _vertics[_routeIndex[0]].position.x,
            _vertics[_routeIndex[0]].position.y,
            _vertics[_routeIndex[0]].position.z
        };
        printf("Init location:(%f, %f, %f)\n", _vertics[_routeIndex[0]].position.x, _vertics[_routeIndex[0]].position.y, _vertics[_routeIndex[0]].position.z);
        [_enemiesArray addObject:e];
        [_camera addMesh:e];
        _newWave = NO;
        
        sleep(3);
    }
}

- (void)render
{
    if (_pause) {
        return;
    }
    
    [self updateEnemyPosition];
}

- (void)updateEnemyPosition
{
    if ([_enemiesArray count] == 0) {
        if (_newWave) {
            return;
        } else {
            _currentWave += 1;
            [self beginWave];
        }
    }
    for (int i = 0; i < [_enemiesArray count]; i++) {
        Enemy *e = [_enemiesArray objectAtIndex:i];
        if (e.finished) {
            NSLog(@"One tank finished.");
            [_enemiesArray removeObject:e];
            [_camera removeMesh:e];
            continue;
        }
        [e render:_vertics[_routeIndex[e.posIndex]].position forRotate:_vertics[_routeIndex[e.posIndex+1]].position];
        //printf("Tank pos: (%f, %f, %f)\n", e.x, e.y, e.z);
    }
}

@end
