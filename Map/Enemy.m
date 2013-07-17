//
//  Enemy.m
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/14/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import "Enemy.h"
#import "GameDataManager.h"

@interface Enemy () {
    int _routeLength;
    float _moveSpeed;
}

- (id)initWithName:(NSString *)name routeLength:(int)len mapWidth:(int)width;

@end

@implementation Enemy

@synthesize posIndex = _posIndex, finished = _finished;

+ (id)enemyByName:(NSString *)name routeLength:(int)len mapWidth:(int)width
{
    return [[Enemy alloc] initWithName:name routeLength:len mapWidth:width];
}

- (id)initWithName:(NSString *)name routeLength:(int)len mapWidth:(int)width
{
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"0.1", kNGLMeshKeyNormalize,
                           nil];
    NSString *meshName = [NSString stringWithFormat:@"%@.obj", name];
    self = [super initWithFile:meshName settings:settings delegate:nil];
    
    if (self) {
        self.name = name;
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

- (void)render:(NGLvec3)pos1 forRotate:(NGLvec3)pos2
{
    if (_posIndex >= _routeLength - 1) {
        NSLog(@"Reach the destination.");
        _finished = YES;
        return;
    }
    
    //printf("Current position: (%f, %f, %f)\n", self.x, self.y, self.z);
    //printf("Next position: (%f, %f, %f)\n", pos1.x, pos1.y, pos1.z);
    NGLvec3 delta = nglVec3Subtract(pos1, *(self.position));
    //printf("Delta: (%f, %f, %f)\n\n", delta.x, delta.y, delta.z);
    float deltaLen = nglVec3Length(delta);
    if (deltaLen < _moveSpeed / 2) {
        NSLog(@"Turn!!!!!!!");
        *self.position = pos1;
        *self.rotation = delta;
        _posIndex += 1;
    }
    float p = _moveSpeed / deltaLen;
    NGLvec3 movVec = (NGLvec3){
        delta.x * p,
        delta.y * p,
        delta.z * p
    };
    
    self.x += movVec.x;
    self.y += movVec.y;
    self.z += movVec.z;
    //printf("Current location:(%f, %f, %f)\n", self.x, self.y, self.z);
}

@end
