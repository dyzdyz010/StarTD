//
//  GameDataManager.m
//  GameDataManager
//
//  Created by 杜 艺卓 on 7/7/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import "GameDataManager.h"

@implementation GameDataManager
static GameDataManager *instance;

+ (GameDataManager *)sharedManager
{
    @synchronized(self) {
        if (!instance) {
            instance = [[super allocWithZone:NULL] init];
        }
    }
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return  self;
}

@end
