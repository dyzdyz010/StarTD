//
//  SceneDataManager.h
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/15/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@interface SceneDataManager : NSObject

@property(nonatomic, readonly, assign) int routeLength;


+ (id)sharedManager;
- (void)loadMap:(Map *)map;
- (NGLvec3)positionByIndex:(int)index;
@end
