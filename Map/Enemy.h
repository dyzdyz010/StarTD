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

@end
