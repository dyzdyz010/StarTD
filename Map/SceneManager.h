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

+ (id)managerForMap:(Map *)map camera:(NGLCamera *)camara race:(NSString *)race;

- (void)addTower:(Tower *)tower;

/*!
 *				暂停游戏。
 */
- (void)gamePause;

/*!
 *				渲染循环。包括出兵过程和炮塔攻击过程。
 */
- (void)render;
@end
