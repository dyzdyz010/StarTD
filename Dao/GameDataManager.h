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
 *				当前所用的种族。
 */
@property(nonatomic, assign) Race race;

/*!
 *				当前可用技能点总数。
 */
@property(nonatomic, assign) int skillPoint;

/*!
 *				单例入口。
 */
+ (id)sharedManager;

/*!
 *				升级对应能力。
 *  @param      name
 *              要升级的能力的名称。
 *
 *  @result     如果升级成功，返回nil，否则返回相应错误。
 */
- (NSError *)upgrade:(NSString *)name;
- (NSError *)downgrade:(NSString *)name;
@end