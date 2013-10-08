//
//  Enemy.m
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/14/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import "Enemy.h"
#import "GameDataManager.h"
#import "SceneManager.h"
#import <math.h>

@interface Enemy () {
    int _routeLength;
    float _moveSpeed;
    SceneManager *_manager;
}

- (id)initWithName:(NSString *)name routeLength:(int)len mapWidth:(int)width manager:(SceneManager *)manager;

@end

@implementation Enemy

@synthesize posIndex = _posIndex, finished = _finished;

+ (id)enemyByName:(NSString *)name routeLength:(int)len mapWidth:(int)width manager:(SceneManager *)manager
{
    return [[Enemy alloc] initWithName:name routeLength:len mapWidth:width manager:manager];
}

- (id)initWithName:(NSString *)name routeLength:(int)len mapWidth:(int)width manager:(SceneManager *)manager
{
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"0.1", kNGLMeshKeyNormalize,
                           nil];
    NSString *meshName = [NSString stringWithFormat:@"%@.obj", name];
    self = [super initWithFile:meshName settings:settings delegate:self];
    
    if (self) {
        _manager = manager;
        self.name = name;
        NGLvec3 pos = [_manager routePositionByIndex:0];
        self.x = pos.x; self.y = pos.y; self.z = pos.z;
        self.rotateY = 90;
        _routeLength = len;
        
        NSDictionary *info = [[GameDataManager sharedManager] enemyByName:name];
        float stepSpeed = 1.0 / (width-1);
        _moveSpeed = [[info valueForKey:MOVESPEED] floatValue] * stepSpeed / 60.0;
        _health = [[info valueForKey:HEALTH] intValue];
        _posIndex = 1;
        
    }
    
    return self;
}

- (void)initDirection:(NGLvec3)direction
{
    NGLvec3 ori = (NGLvec3){0.0, 0.0, 1.0};
    double angle = acos(nglVec3Dot(ori, direction) / (nglVec3Length(ori) * nglVec3Length(direction)));
    self.rotateY = angle;
}

- (void)render:(NGLvec3)pos1 forRotate:(NGLvec3)pos2
{
    if (_posIndex >= _routeLength - 2 || _health <= 0) {
        _finished = YES;
        if (_health <= 0) {
            _health = 0;
        }
        return;
    }
    
    NGLvec3 delta = nglVec3Subtract(pos1, *(self.position));
    float deltaLen = nglVec3Length(delta);
    if (deltaLen < _moveSpeed / 2) {
        //NGLvec3 vec1 = nglVec3Subtract(pos1, pos0);
        NGLvec3 vec1 = (NGLvec3){1.0, 0.0, 0.0};
        NGLvec3 vec2 = nglVec3Subtract(pos2, pos1);
        double angle = 0;
        float cosine = nglVec3Dot(vec1, vec2) / (nglVec3Length(vec1) * nglVec3Length(vec2));
        if (cosine > 1.0 || cosine < -1.0) {
            printf("Cosine: %f\n", cosine);
            (cosine > 1.0) ? (cosine = 1.0) : (cosine = -1.0);
        }
        angle = acos(cosine);
        angle = 90 - angle * 180.0 / 3.14;
        //NSLog(@"angle: %f", angle);
        self.rotateY = angle;
        
        _posIndex += 1;
    }
    float p = _moveSpeed / deltaLen;
    NGLvec3 movVec = (NGLvec3){
        delta.x * p,
        delta.y * p,
        delta.z * p
    };
    
    self.x += movVec.x;
    //self.y += movVec.y;
    self.z += movVec.z;
    //printf("Current location:(%f, %f, %f)\n", self.x, self.y, self.z);
}

- (void)meshLoadingDidFinish:(NGLParsing)parsing
{
    self.rotateY = 90;
}

@end
