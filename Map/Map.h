//
//  Map.h
//  IndicesTest
//
//  Created by 杜 艺卓 on 7/9/13.
//
//

#import <Foundation/Foundation.h>

#define NAME @"height-map"

#pragma mark -
#pragma mark Vector operation functions
//**********************************************************************************************************
//
//	数据结构
//
//**********************************************************************************************************

NGLvec3 add(NGLvec3, NGLvec3);
NGLvec3 minus(NGLvec3, NGLvec3);
NGLvec3 cross(NGLvec3, NGLvec3);
NGLvec3 divide(NGLvec3, int);

BOOL equal(NGLvec3, NGLvec3);
#pragma mark -


typedef struct {
    NGLvec3 position;
    NGLvec3 normal;
    NGLvec2 texCoor;
} Vertex;

typedef struct {
    Vertex pos0, pos1, pos2;
    NGLvec3 normal;
} Face;

typedef struct WayPoint {
    int index;
    struct WayPoint *next;
} WayPoint;

@interface Map : NGLMesh {
}

/*!
 *				地形宽度。
 */
@property (nonatomic, readonly, assign) NSInteger width;

/*!
 *				地形高度。
 */
@property (nonatomic, readonly, assign) NSInteger height;

/*!
 *				敌方单位路径指针。
 */
@property (nonatomic, readonly, assign) WayPoint *route;

/*!
 *				根据指定名称获取地图对象。
 *
 *  @param      name
 *              要获取的地图的名称。
 */
+ (id)mapFromName:(NSString *)name;

/*!
 *				载入地图数据，包括地形和路径。
 */
- (void)load;

@end
