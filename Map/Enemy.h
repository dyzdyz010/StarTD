//
//  Enemy.h
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/14/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import <NinevehGL/NinevehGL.h>

@interface Enemy : NGLMesh

/*!
 *              当前所在的位置索引。
 */
@property (nonatomic, readonly, assign) int pos;

/*!
 *              单位的移动速度。
 */
@property (nonatomic, readonly, assign) float moveSpeed;

/*!
 *              单位的生命值。
 */
@property (nonatomic, readonly, assign) int health;

/*!
 *              单位出现的数量。
 */
@property (nonatomic, readonly, assign) int amount;

/*!
 *              获取指定名称的敌人单位对象。
 *
 *  @param      要获取的单位的名称。
 */
+ (id)enemyByName:(NSString *)name;

- (void)move;

@end
