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
    NSMutableArray *_enemiesArray;
    NSMutableArray *_towersArray;
}
- (id)initWithMap:(Map *)map camera:(NGLCamera *)camara;

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
        
        _enemiesArray = [[NSMutableArray alloc] init];
        Enemy *e = [Enemy enemyByName:@"Tank" routeLength:_routeLength mapWidth:map.width];
        *e.position = (NGLvec3){
            _vertics[_routeIndex[0]].position.x + 0.5,
            _vertics[_routeIndex[0]].position.y,
            _vertics[_routeIndex[0]].position.z + 0.5
        };
        printf("Init location:(%f, %f, %f)", _vertics[_routeIndex[0]].position.x, _vertics[_routeIndex[0]].position.y, _vertics[_routeIndex[0]].position.z);
        [_enemiesArray addObject:e];
        [camara addMesh:e];
    }
    
    return self;
}

- (void)render
{
    [self updateEnemyPosition];
}

- (void)updateEnemyPosition
{
    for (Enemy *e in _enemiesArray) {
        [e render:_vertics[e.posIndex].position forRotate:_vertics[e.posIndex + 1].position];
    }
}

@end
