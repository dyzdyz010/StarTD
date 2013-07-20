//
//  CSmoke.m
//  Assignment1
//
//  Created by 刘萌 on 13-7-10.
//
//

#import "CSmoke.h"

@implementation CSmoke

-(void) InitSmokeText: (NSString*)text Setting: (NSDictionary*)seting BulletSize:(float)size
{
    m_smokesize = size;
    alphasize = 1.0f;
    float structures[] = {
        -m_smokesize, -m_smokesize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f,
         m_smokesize, -m_smokesize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f,
         m_smokesize,  m_smokesize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
        -m_smokesize,  m_smokesize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f, 1.0f,
    };
    
    unsigned int indices[] = {
        0,1,2,
        2,3,0,
    };
    
    NGLMeshElements *elements = [[NGLMeshElements alloc] init];
    [elements addElement:(NGLElement){NGLComponentVertex, 0, 4, 0}];
    [elements addElement:(NGLElement){NGLComponentNormal, 4, 3, 0}];
    [elements addElement:(NGLElement){NGLComponentTexcoord, 7, 2, 0}];

    material = [NGLMaterial material];
    material.alpha = alphasize;
    material.diffuseMap = [NGLTexture texture2DWithImage:[UIImage imageNamed:text]];
    
    _SmokeParticle = [[NGLMesh alloc] init];
    [_SmokeParticle setIndices:indices count:6];
    [_SmokeParticle setStructures:structures count:36 stride:9];
    [_SmokeParticle.meshElements addFromElements:elements];
    _SmokeParticle.material = material;
    //[_SmokeParticle performSelector:@selector(updateCoreMesh)];
  }
-(void)SetAlpha:(float)alpha
{
    alphasize = 1.0;
}
-(void)RenderSmoke: (float)alphanow
{
    if (alphasize<0.1) {
        alphasize = 1.0;
    }
    alphasize = alphasize - 0.1;
    material.alpha = alphasize;
}

- (NGLMesh*) GetSmokeMesh
{
    return _SmokeParticle;
}

- (void)SetSmokeSize:(float)size
{
    m_smokesize = size;
}

-(float) GetAlpha
{
    return alphasize;
}

- (void)SetSmokePos:(NGLvec3)pos
{
    m_smokepos = pos;
    _SmokeParticle.x = m_smokepos.x;
    _SmokeParticle.y = m_smokepos.y;
    _SmokeParticle.z = m_smokepos.z;
}

-(void)Update: (NGLvec3)g_vpos
{
}
















@end
