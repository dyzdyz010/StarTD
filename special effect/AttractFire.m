//
//  AttractFire.m
//  Assignment1
//
//  Created by 刘萌 on 13-7-13.
//
//

#import "AttractFire.h"

@implementation AttractFire

- (void) InitExposionPos:(NGLvec3)pos Setting:(NSDictionary *)setting
{
    exposionsize = 0.05;
    currentmesh = 0;
    float structures[] = {
        pos.x-exposionsize, pos.y-exposionsize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f,
        pos.x+exposionsize, pos.y-exposionsize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f,
        pos.x+exposionsize, pos.y+exposionsize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
        pos.x-exposionsize, pos.y+exposionsize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f, 1.0f,
    };
    
    unsigned int indices[] = {
        0,1,2,
        2,3,0,
    };
    
    NGLMeshElements *elements = [[NGLMeshElements alloc] init];
    [elements addElement:(NGLElement){NGLComponentVertex, 0, 4, 0}];
    [elements addElement:(NGLElement){NGLComponentNormal, 4, 3, 0}];
    [elements addElement:(NGLElement){NGLComponentTexcoord, 7, 2, 0}];
    
    nglGlobalColorFormat(NGLColorFormatRGBA);
    nglGlobalFlush();
    
    textname[0] = @"fire_1.png";
    textname[1] = @"fire_2.png";
    textname[2] = @"fire_3.png";
    textname[3] = @"fire_4.png";
    textname[4] = @"fire_5.png";
    textname[5] = @"fire_6.png";
    textname[6] = @"fire_7.png";
    textname[7] = @"fire_8.png";
    textname[8] = @"fire_9.png";
    
    material = [NGLMaterial material];
    
    for (int i=0; i<EX_MESHSIZE; i++) {
        material.diffuseMap = [NGLTexture texture2DWithImage:[UIImage imageNamed:textname[i]]];
        _exposion[i] = [[NGLMesh alloc] init];
        [_exposion[i] setIndices:indices count:6];
        [_exposion[i] setStructures:structures count:36 stride:9];
        [_exposion[i].meshElements addFromElements:elements];
        _exposion[i].material = material;
        [_exposion[i] performSelector:@selector(updateCoreMesh)];
    }
}

- (NGLMesh*) GetMesh
{
    return _exposion[currentmesh];
}

- (void)UpdateTexture:(float)time
{
    int timeint = time;
  
    currentmesh = timeint%EX_CHANGEVELOCITY;
    currentmesh = currentmesh/EX_MESHSIZE;
}

- (int)GetCurrentMesh
{
    return currentmesh;
}

- (void) dealloc
{
    for (int i=0; i<EX_MESHSIZE; i++) {
        [_exposion[i] release];
    }
    
    [material release];
    
	[super dealloc];
}


@end
