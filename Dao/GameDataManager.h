//
//  GameDataManager.h
//  GameDataManager
//
//  Created by 杜 艺卓 on 7/7/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import <Foundation/Foundation.h>

//**********************************************************************************************************
//
//	数据键宏
//
//**********************************************************************************************************

// Attack Definitions
#define ATTACK_RATE @"attack-rate"
#define ATTACK_BOUND @"attack-bound"
#define ATTACK_SPEED @"attack-speed"

// Defense Definitions
#define DEFENSE_RATE @"defense-rate"
#define HEALTH_RATE @"health-rate"

typedef enum {
    Terran = 0,
    Protoss = 1,
    Zerg = 2
} Race;

typedef struct{
    int attackRate;
    int attackBound;
    int attachSpeed;
    
    int defenseRate;
    int healthRate;
} Upgrades;

@interface GameDataManager : NSObject {
    NSDictionary *_infoDic;
}

/*!
 *				当前所用的种族。
 */
@property(nonatomic, assign) Race race;

/*!
 *				当前可用技能点总数。
 */
@property(nonatomic, assign) int skillPoint;
@property(nonatomic, assign) int score;

+ (id)sharedManager;
@end