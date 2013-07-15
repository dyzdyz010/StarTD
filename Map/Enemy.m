//
//  Enemy.m
//  StarTD-Framework
//
//  Created by 杜 艺卓 on 7/14/13.
//  Copyright (c) 2013 BJTU. All rights reserved.
//

#import "Enemy.h"

@interface Enemy ()

- (id)initWithName:(NSString *)name;

@end

@implementation Enemy

@synthesize pos = _pos;

+ (id)enemyByName:(NSString *)name
{
    return [[Enemy alloc] initWithName:name];
}

- (id)initWithName:(NSString *)name
{
    NSString *meshName = [NSString stringWithFormat:@"%@.obj", name];
    self = [super initWithFile:meshName settings:Nil delegate:nil];
    
    if (self) {
        self.name = name;
    }
    
    return self;
}

- (void)move
{
    if (_pos < 120) {
        _pos += 1;
    }
}

@end
