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
                           @"0.3", kNGLMeshKeyNormalize,
                           nil];
    NSString *meshName = [NSString stringWithFormat:@"%@.obj", name];
    self = [super initWithFile:meshName settings:settings delegate:nil];
    
    if (self) {
        self.name = name;
        _routeLength = len;
        
        NSDictionary *info = [[GameDataManager sharedManager] enemyByName:name];
        float stepSpeed = 1.0 / width;
        _moveSpeed = [[info valueForKey:MOVESPEED] floatValue] * stepSpeed / 60;
        _health = [[info valueForKey:HEALTH] intValue];
        _posIndex = 1;
        
    }
    
    return self;
}

- (void)render:(NGLvec3)pos1 forRotate:(NGLvec3)pos2
{
    if (_posIndex == _routeLength + 1) {
        //NSLog(@"Reach the destination.");
        _finished = YES;
        return;
    }
    
    //NSLog(@"Next index: %d", _posIndex);
    NGLvec3 delta = nglVec3Subtract(pos1, *(self.position));
    if (nglVec3Length(delta) < _moveSpeed / 2) {
        //NSLog(@"Turn!!!!!!!");
        *self.position = pos1;
        *self.rotation = delta;
        _posIndex += 1;
    }
    *self.position = nglVec3Add(*self.position, delta);
    //printf("Current location:(%f, %f, %f)\n", self.x, self.y, self.z);
}

@end
