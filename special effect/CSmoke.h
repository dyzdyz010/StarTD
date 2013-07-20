//
//  CSmoke.h
//  Assignment1
//
//  Created by 刘萌 on 13-7-10.
//
//

#import <NinevehGL/NinevehGL.h>


@interface CSmoke : NGLMesh
{
    NGLMesh *_SmokeParticle;
    float   alphasize;
    NGLMaterial *material;
    //-------子弹自己来设置的烟雾的属性---------//
    NGLvec3 m_smokepos;
    float   m_smokesize;
}

-(void) InitSmokeText: (NSString*)text Setting: (NSDictionary*)seting BulletSize:(float)size;
- (NGLMesh*) GetSmokeMesh;
- (float) GetAlpha;
- (void)RenderSmoke: (float)alphanow;

- (void)SetSmokePos: (NGLvec3)pos;
- (void)SetSmokeSize: (float)size;
- (void)Update: (NGLvec3) g_vpos;
- (void)SetAlpha: (float) alpha;
@end