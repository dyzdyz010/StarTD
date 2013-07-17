//
//  SceneManager.h
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/15/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@interface SceneManager : NSObject

@property (nonatomic, readonly, assign) int routeLength;

@property (nonatomic, retain) NSMutableArray *enemiesArray;

@property (nonatomic, assign) Vertex *vertics;

+ (id)managerForMap:(Map *)map camera:(NGLCamera *)camara;

- (void)render;
@end
