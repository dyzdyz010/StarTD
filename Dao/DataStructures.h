//
//  DataStructures.h
//  GameDataManager
//
//  Created by 杜 艺卓 on 7/11/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#pragma mark -
#pragma mark Data Key Definitions
//**********************************************************************************************************
//
//	数据键宏
//
//**********************************************************************************************************

// 顶层数据键
#define USER     @"User"
#define MISSIONS @"Missions"
#define SETTINGS @"Settings"
#define UPGRADES @"Upgrades"
#define ENEMIES  @"Enemies"

// User definitions
#define SKILLPOINT @"skill-point"
#define LEVEL @"level"

// Missions definitions
#define NAME @"name"
#define WAVE @"wave"

// Settings definitions
#define LANGUAGE @"language"
#define SOUND @"sound"
#define EFFECT @"effect"
#define MUSIC @"music"
#define MUTE @"mute"
#define VOLUME @"volume"

// Graphics definitions
#define GRAPHICS @"graphics"
#define TEXTURE @"texture"
#define QUALITY @"quality"
#define ANTIALIAS @"antialias"
#define SHADERS @"shaders"
#define LIGHTING @"lighting"
#define SHADOWS @"shadows"
#define POSTPROCESSING @"post-processing"
#define PHYSICS @"physics"
#define MODELS @"models"

// Upgrades definitions
#define ATTACKRATE @"attack-rate"
#define ATTACKBOUND @"attack-bound"
#define ATTACKSPEED @"attack-speed"
#define DEFENSERATE @"defense-rate"
#define HEALTHRATE @"health-rate"
#define UPGRADELEVELMAX 3
#define UPGRADELEVELMIN 0

// Enemies definitions
#define AMOUNT @"amount"
#define MOVESPEED @"move-speed"
#define HEALTH @"health"

// Race definitions
#define PROTOSS @"protoss"
#define TERRAN @"terran"
#define ZERG @"zerg"

#pragma mark -
#pragma mark Data structure definitions
//**********************************************************************************************************
//
//	数据结构
//
//**********************************************************************************************************

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

/*!
 *				升级错误信息。
 */
typedef enum {
    UELevelMax = -1000,
    UELevelMin
} UpgradeError;



