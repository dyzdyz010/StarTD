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
    //Vertex *_vertics;
    int *_routeIndex;
    //NSMutableArray *_enemiesArray;
    NSMutableArray *_towersArray;
}
- (id)initWithMap:(Map *)map camera:(NGLCamera *)camara;

- (void)updateEnemyPosition;

@end

@implementation SceneManager

@synthesize routeLength = _routeLength, enemiesArray = _enemiesArray, vertics = _vertics;

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
        
        _enemiesArray = [[NSMutableArray alloc] init];
        Enemy *e = [Enemy enemyByName:@"Tank" routeLength:_routeLength mapWidth:map.width];
        *e.position = (NGLvec3){
            _vertics[_routeIndex[0]].position.x,
            _vertics[_routeIndex[0]].position.y,
            _vertics[_routeIndex[0]].position.z
        };
        printf("Init location:(%f, %f, %f)\n", _vertics[_routeIndex[0]].position.x, _vertics[_routeIndex[0]].position.y, _vertics[_routeIndex[0]].position.z);
        [_enemiesArray addObject:e];
        [camara addMesh:e];
        
        for (int i = 0; i < _routeLength; i++) {
            printf("Waypoint: (%f, %f, %f)\n", _vertics[_routeIndex[i]].position.x, _vertics[_routeIndex[i]].position.y, _vertics[_routeIndex[i]].position.z);
        }
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
