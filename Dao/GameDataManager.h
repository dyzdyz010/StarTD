//
//  GameDataManager.h
//  GameDataManager
//
//  Created by 杜 艺卓 on 7/7/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "DataStructures.h"

@interface GameDataManager : NSObject {
    NSMutableDictionary *_infoDic;
    NSString *dstPath;
}

/*!
 *				当前可用技能点总数。
 */
@property (nonatomic, retain) NSNumber *skillPoint;

/*!
 *				当前游戏中所用语言。
 */
@property (nonatomic, retain) NSString *language;

/*!
 *				当前游戏中所用的设置。
 */
@property (nonatomic, retain) NSDictionary *settings;

/*!
 *				单例入口。
 *
 *  @result     返回GameDataManager单实例对象。
 */
+ (id)sharedManager;

#pragma mark -
#pragma mark 升级相关

/*!
 *				获取对应能力的等级。
 *  @param      name
 *              要获取等级的能力的名称。
 *
 *  @result     对应能力的等级。
 */
- (NSInteger)levelForSkill:(NSString *)name;

/*!
 *				升级对应能力。
 *  @param      name
 *              要升级的能力的名称。
 *
 *  @result     如果升级成功，返回nil，否则返回相应错误。
 */
- (NSError *)upgrade:(NSString *)name;

/*!
 *				降级对应能力。
 *  @param      name
 *              要降级的能力的名称。
 *
 *  @result     如果降级成功，返回nil，否则返回相应错误。
 */
- (NSError *)downgrade:(NSString *)name;

#pragma mark -
#pragma mark 关卡相关

/*!
 *              获取指定关卡。
 *
 *  @param      index
 *              要获取的关卡的序号，范围为0-3。
 *
 *  @result     指定的关卡Dictionary，包含关卡名称和敌人波数。
 */
- (NSDictionary *)missionByIndex:(NSInteger)index;

/*!
 *              获取制定种族的敌人单位列表。
 *
 *  @param      race
 *              指定的种族。
 *
 *  @result     对应种族的敌人单位列表。
 */
- (NSArray *)enemiesByRace:(NSString *)race;
@end