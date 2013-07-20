//
//  AreaAttract.m
//  Assignment1
//
//  Created by 刘萌 on 13-7-13.
//
//

#import "AreaAttract.h"

@implementation AreaAttract

- (void) InitAreaAttractStarPos:(NGLvec3)starpos EndPos:(NGLvec3)enpos Setting:(NSDictionary *)setting
{
    areasize = 0.25;
    currentmesh = 0;
    float structures[] = {
        starpos.x, starpos.y-areasize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f,
        enpos.x,  enpos.y-areasize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f,
        enpos.x,  enpos.y+areasize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f,
        starpos.x,starpos.y+areasize, 0.0f, 1.0f, 1.0f, 1.0f, 1.0f, 0.0f, 1.0f,
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
    
    textname[0] = @"flight_1.png";
    textname[1] = @"flight_2.png";
    textname[2] = @"flight_3.png";
    textname[3] = @"flight_4.png";
    textname[4] = @"flight_5.png";

    material = [NGLMaterial material];
   
   
    for (int i=0; i<AB_MESHSIZE; i++) {
         material.diffuseMap = [NGLTexture texture2DWithImage:[UIImage imageNamed:textname[i]]];
        _areabullet[i] = [[NGLMesh alloc] init];
        [_areabullet[i] setIndices:indices count:6];
        [_areabullet[i] setStructures:structures count:36 stride:9];
        [_areabullet[i].meshElements addFromElements:elements];
        _areabullet[i].material = material;
        //[_areabullet[i] performSelector:@selector(updateCoreMesh)];
    }
}

//-----------------返回当前在摄像机中的mesh-----------------//
- (NGLMesh*) GetMesh
{
    return _areabullet[currentmesh];
}

//---------------根据主程序的运行时间更新mesh-----------------//
- (void)UpdateTexture:(float)time
{
    int timeint = time;
    currentmesh = timeint%AB_CHANGEVELOCITY;
    currentmesh = currentmesh/AB_MESHSIZE;
   }

//---------------返回当前应该是运行到几号mesh---------------//
- (int)GetCurrentMesh
{
    return currentmesh;
}

@end
