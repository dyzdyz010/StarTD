//
//  AttractFire.h
//  Assignment1
//
//  Created by 刘萌 on 13-7-13.
//
//

#import <NinevehGL/NinevehGL.h>
#define EX_MESHSIZE 9
#define EX_CHANGEVELOCITY 9

@interface AttractFire : NGLObject3D
{
@protected
    NGLMesh       *_exposion[9];   //9个mesh
    NGLMaterial   *material;       //mesh的材质
    int           currentmesh;     //当前在摄像机中的mesh
    NSString      *textname[9];    //纹理的名字
    float         exposionsize;    //爆炸效果面片大小
}

- (void) InitExposionPos: (NGLvec3)pos Setting: (NSDictionary*)setting;
- (void)UpdateTexture: (float)time;
- (NGLMesh*) GetMesh;
- (int)GetCurrentMesh;
@end
