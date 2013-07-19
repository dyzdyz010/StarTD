//
//  AreaAttract.h
//  Assignment1
//
//  Created by 刘萌 on 13-7-13.
//
//

#import <NinevehGL/NinevehGL.h>
#define AB_MESHSIZE 5          //定义有多少个mesh
#define AB_CHANGEVELOCITY 25   //定义mesh更新的速度

@interface AreaAttract : NGLObject3D
{
    @protected
    NGLMesh     *_areabullet[5];   //5个mesh
    NGLMaterial *material;         //mesh上的材质
    int         currentmesh;       //程序当前的mesh号
    NSString    *textname[5];      //5张贴图
    float       areasize;          //闪电攻击大面片大小
}

- (void) InitAreaAttractStarPos: (NGLvec3)starpos EndPos: (NGLvec3)enpos Setting: (NSDictionary*)setting;
- (void)UpdateTexture: (float)time;
- (NGLMesh*) GetMesh;
- (int)GetCurrentMesh;
@end
