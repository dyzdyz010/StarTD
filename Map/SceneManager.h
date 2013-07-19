//
//  SceneManager.h
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/15/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@class Enemy;

typedef enum {
    InProcess = 0,
    Win,
    Lose
} GameStatus;

@interface SceneManager : NSObject

/*!
 *				路径长度。
 */
@property (nonatomic, readonly, assign) int routeLength;

/*!
 *				地图宽度。
 */
@property (nonatomic, readonly, assign) int mapWidth;

/*!
 *				放塔位置数组。
 */
@property (nonatomic, readonly, assign) TowerPosition *twPositionSet;

/*!
 *				游戏状态。
 */
@property (nonatomic, readonly, assign) GameStatus status;

/*!
 *				游戏内的金钱。
 */
@property (nonatomic, readonly, assign) int money;

+ (id)managerForMap:(Map *)map camera:(NGLCamera *)camara race:(NSString *)race;

/*!
 *				添加炮塔。
 *
 *  @param      要添加的炮塔的名称
 */
- (void)addTowerByName:(NSString *)name position:(int)index cost:(int)cost;

/*!
 *				暂停游戏。
 */
- (void)gamePause;

/*!
 *				渲染循环。包括出兵过程和炮塔攻击过程。
 */
- (void)render;

- (NGLvec3)routePositionByIndex:(int)index;

- (NGLvec3)towerPositionByIndex:(int)index;

- (Enemy *)enemyOnPosition:(int)index;

@end
