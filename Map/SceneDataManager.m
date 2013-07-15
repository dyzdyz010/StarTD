//
//  SceneDataManager.m
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/15/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import "SceneDataManager.h"

@interface SceneDataManager () {
    Vertex *_vertics;
    int *_routeIndex;
}

@end

static SceneDataManager *instance;

@implementation SceneDataManager

@synthesize routeLength = _routeLength;

+ (SceneDataManager *)sharedManager
{
    @synchronized(self) {
        if (!instance) {
            instance = [[super allocWithZone:NULL] init];
        }
    }
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return  self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)loadMap:(Map *)map
{
    _vertics = map.vertics;
    _routeLength = map.routeLength;
    _routeIndex = (int *)calloc(_routeLength, sizeof(int));
    WayPoint *now = map.route;
    while (now->next) {
        
    }
}

- (NGLvec3)positionByIndex:(int)index
{
    return (NGLvec3){};
}

@end
