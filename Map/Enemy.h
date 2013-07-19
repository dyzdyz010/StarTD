//
//  Enemy.h
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/14/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import <NinevehGL/NinevehGL.h>

@class SceneManager;

@interface Enemy : NGLMesh <NGLMeshDelegate>

/*!
 *              下一个要到达的位置的索引。
 */
@property (nonatomic, readonly, assign) int posIndex;

/*!
 *              单位的生命值。
 */
@property (nonatomic, readwrite, assign) int health;

/*!
 *              单位出现的数量。
 */
@property (nonatomic, readonly, assign) int amount;

/*!
 *              单位是否已经走到路径终点。
 */
@property (nonatomic, readonly, assign) BOOL finished;

/*!
 *              获取指定名称的敌人单位对象。
 *
 *  @param      name
 *              要获取的单位的名称。
 *
 *  @param      len
 *              路径长度。
 *
 *  @param      width
 *              地图宽度。
 *
 *  @param      manager
 *              所属的SceneManager对象。
 *
 *  @result     对应的敌人单位对象。
 */
+ (id)enemyByName:(NSString *)name routeLength:(int)len mapWidth:(int)width manager:(SceneManager *)manager;

/*!
 *              设置对象的初始方向。
 *
 *  @param      direction
 *              方向向量。
 */
- (void)initDirection:(NGLvec3)direction;

/*!
 *              更新自身的位置。
 *
 *  @param      要获取的单位的名称。
 */
- (void)render:(NGLvec3)pos1 forRotate:(NGLvec3)pos2;

@end
