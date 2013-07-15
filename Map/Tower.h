//
//  Tower.h
//  GameSceneTest
//
//  Created by 杜 艺卓 on 7/12/13.
//
//

#import <NinevehGL/NinevehGL.h>

@interface Tower : NGLMesh <NGLMeshDelegate>

/*!
 *				炮塔的攻击力。
 */
@property (nonatomic, readonly, assign) float attackRate;

/*!
 *				炮塔的攻击范围。
 */
@property (nonatomic, readonly, assign) float attackBound;

/*!
 *				炮塔的攻击速度。
 */
@property (nonatomic, readonly, assign) float attackSpeed;

/*!
 *				购买炮塔所要花费的晶矿数量。
 */
@property (nonatomic, readonly, assign) int cost;

/*!
 *				根据指定名称获取对应的炮塔对象。
 *
 *  @param      name
 *              要获取的炮塔对象的名称。
 *
 *  @param      race
 *              要获取的炮塔所属种族。
 *
 *  @result     指定的炮塔对象。
 */
+ (id)towerByName:(NSString *)name race:(NSString *)race;

@end
