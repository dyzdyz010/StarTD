//
//  Map.m
//  IndicesTest
//
//  Created by 杜 艺卓 on 7/9/13.
//
//

#import "Map.h"
#include "math.h"

NGLvec3 add(NGLvec3 a, NGLvec3 b)
{
    NGLvec3 c;
    c.x = a.x + b.x;
    c.y = a.y + b.y;
    c.z = a.z + b.z;
    return c;
}

NGLvec3 minus(NGLvec3 a, NGLvec3 b)
{
    NGLvec3 c;
    c.x = a.x - b.x;
    c.y = a.y - b.y;
    c.z = a.z - b.z;
    return c;
}

NGLvec3 cross(NGLvec3 a, NGLvec3 b)
{
    NGLvec3 c;
    c.x = a.y * b.z - b.y * a.z;
    c.y = a.z * b.x - a.x * b.z;
    c.z = a.x * b.y - b.x * a.y;
    return c;
}

NGLvec3 divide(NGLvec3 a, int n)
{
    NGLvec3 b;
    b.x = a.x / n;
    b.y = a.y / n;
    b.z = a.z / n;
    return b;
}

BOOL equal(NGLvec3 a, NGLvec3 b)
{
    if (a.x == b.x && a.y == b.y && a.z == b.z) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -

@interface Map () {
    Byte *_heightData;
    unsigned int *_indices;
}
- (id)initWithName:(NSString *)name;

- (void)loadMesh;
- (void)loadHeightMap;
- (void)loadNormal;
- (NSError *)loadNormalMap;
- (void)loadTexCoor;
- (void)generateRoute;
@end

@implementation Map

@synthesize width = _width, height = _height, route = _route, vertics = _vertics, routeLength = _routeLength;

+ (id)mapFromName:(NSString *)name
{
    return [[Map alloc] initWithName:name];
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.name = name;
    }
    
    return self;
}

- (void)load
{
    [self loadMesh];
}

- (void)loadMesh
{
    [self loadHeightMap];
    [self loadTexCoor];
    
    _indices = (unsigned int*)calloc((_width-1) * (_height-1) * 6, sizeof(unsigned int));
    
    for (int i = 0; i < (_width-1) * (_height-1); i++) {
        _indices[i * 6]     =          i / (_width - 1) * _width + (i % (_width-1));
        _indices[i * 6 + 1] = _width + i / (_width - 1) * _width + (i % (_width-1));
        _indices[i * 6 + 2] = _width + i / (_width - 1) * _width + (i % (_width-1)) + 1;
    
        _indices[i * 6 + 3] = _width + i / (_width - 1) * _width + (i % (_width-1)) + 1;
        _indices[i * 6 + 4] =          i / (_width - 1) * _width + (i % (_width-1)) + 1;
        _indices[i * 6 + 5] =          i / (_width - 1) * _width + (i % (_width-1));
    }
    [self loadNormalMap];
    
    float *_structures = (float *)calloc(_width * _height * 9, sizeof(float));
    for (int i = 0; i < _width * _height; i++) {
        _structures[i * 9] = _vertics[i].position.x;
        _structures[i * 9 + 1] = _vertics[i].position.y;
        _structures[i * 9 + 2] = _vertics[i].position.z;
        _structures[i * 9 + 3] = 1.0;
        _structures[i * 9 + 4] = _vertics[i].normal.x;
        _structures[i * 9 + 5] = _vertics[i].normal.y;
        _structures[i * 9 + 6] = _vertics[i].normal.z;
        _structures[i * 9 + 7] = _vertics[i].texCoor.x;
        _structures[i * 9 + 8] = _vertics[i].texCoor.y;
    }
    
    

    
    NGLMeshElements *elements = [[NGLMeshElements alloc] init];
    [elements addElement:(NGLElement){NGLComponentVertex, 0, 4, 0}];
    [elements addElement:(NGLElement){NGLComponentNormal, 4, 3, 0}];
    [elements addElement:(NGLElement){NGLComponentTexcoord, 7, 2, 0}];
    
    NGLMaterial *material = [NGLMaterial material];
    //NSLog(@"Shinness: %f", material.shininess);
    material.shininess = 10;
    material.diffuseMap = [NGLTexture texture2DWithImage:[UIImage imageNamed:@"grass.jpg"]];
    
    [self setIndices:_indices count:(_width-1) * (_height-1) * 6];
    [self setStructures:_structures count:_width * _height * 9 stride:9];
    [self.meshElements addFromElements:elements];
    self.material = material;
    
    //NGLShaders *shader = [NGLShaders shadersWithFilesVertex:@"shader.vsh" andFragment:@"shader.fsh"];
    //_mesh.shaders = shader;
    //[self compileCoreMesh];
    [self performSelector:@selector(updateCoreMesh)];
}

- (void)loadHeightMap
{
    UIImage *heightmap = [UIImage imageNamed:self.name];
    CGImageRef imageRef = [heightmap CGImage];
    _width = CGImageGetWidth(imageRef);
    _height = CGImageGetHeight(imageRef);
    NSLog(@"Width: %d, Height: %d", _width, _height);
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    NSData *data = (__bridge id)CGDataProviderCopyData(provider);
    Byte *bytes = (Byte *)[data bytes];
    _heightData = calloc(_width * _height, sizeof(Byte));
    for (int i = 0; i < _width * _height; i++) {
        _heightData[i] = bytes[i * 4];
    }
    [self generateRoute];
    
    _vertics = (Vertex *)calloc(_width * _height, sizeof(Vertex));
    for (int i = 0; i < _width * _height; i++) {
        _vertics[i] = (Vertex){
            i % _width * 1.0 / _width - 0.5,
            _heightData[i] * 1.0 / 255.0,
            i / _width * 1.0 / _height - 0.5,
            0.0, 0.0, 0.0,
            0.0, 0.0
        };
    }
}

#pragma mark -
//**********************************************************************************************************
//
//	计算法线（法线平均算法、导入法线贴图）
//
//**********************************************************************************************************
#pragma mark 法线相关

- (void)loadNormal
{
    
    
    Face *_faces = (Face *)calloc((_width-1) * (_height-1) * 2, sizeof(Face));
    
    for (int i = 0; i < (_width-1) * (_height-1); i++) {
        _faces[i*2] = (Face){
            _vertics[         i / (_width - 1) * _width + (i % (_width-1))],
            _vertics[_width + i / (_width - 1) * _width + (i % (_width-1))],
            _vertics[_width + i / (_width - 1) * _width + (i % (_width-1)) + 1],
            {0.0, 0.0, 0.0}
        };
        NGLvec3 a = minus(_faces[i*2].pos1.position, _faces[i*2].pos0.position);
        NGLvec3 b = minus(_faces[i*2].pos2.position, _faces[i*2].pos1.position);
        _faces[i*2].normal = cross(a, b);
        
        _faces[i*2 + 1] = (Face){
            _vertics[_width + i / (_width - 1) * _width + (i % (_width-1)) + 1],
            _vertics[         i / (_width - 1) * _width + (i % (_width-1)) + 1],
            _vertics[         i / (_width - 1) * _width + (i % (_width-1))],
            {0.0, 0.0, 0.0}
        };
        NGLvec3 c = minus(_faces[i*2 + 1].pos1.position, _faces[i*2 + 1].pos0.position);
        NGLvec3 d = minus(_faces[i*2 + 1].pos2.position, _faces[i*2 + 1].pos1.position);
        _faces[i*2 + 1].normal = cross(c, d);
        //printf("Normal:(%f, %f, %f)\n", _faces[i*2].normal.x, _faces[i*2].normal.y, _faces[i*2].normal.z);
    }
    
    Byte *normalBytes = (Byte *)calloc(_width * _height * 4, sizeof(Byte));
    for (int i = 0; i < _width * _height; i++) {
        NGLvec3 norm = {0.0, 0.0, 0.0};
        int num = 0;
        for (int j = 0; j < (_width-1) * (_height-1) * 2; j++) {
            if (equal(_vertics[i].position, _faces[j].pos0.position) ||
                equal(_vertics[i].position, _faces[j].pos1.position) ||
                equal(_vertics[i].position, _faces[j].pos2.position)) {
                
                norm = add(norm, _faces[j].normal);
                num++;
            }
        }
        _vertics[i].normal = divide(norm, num);
        normalBytes[i*4] = _vertics[i].normal.x * 1000000;
        normalBytes[i*4+1] = _vertics[i].normal.y * 1000000 + 130;
        normalBytes[i*4+2] = -_vertics[i].normal.z * 1000000;
        normalBytes[i*4+3] = 255;
    }
    for (int i = 0; i < _width * _height; i++) {
        printf("Normal: (%d, %d, %d)\n", (int)(_vertics[i].normal.x*1000000), (int)(_vertics[i].normal.y*1000000), (int)(_vertics[i].normal.z*1000000));
    }
    NSString *path = [NSString stringWithFormat:@"%@/Documents/normal.png", NSHomeDirectory()];
    UIImage *img = nil;
    CGDataProviderRef dpRef = CGDataProviderCreateWithData(NULL, normalBytes, _width * _height * 4, nil);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef imgRef = CGImageCreate(_width, _height, 8, 32, 4*_width, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, dpRef, NULL, NO, kCGRenderingIntentDefault);
    img = [UIImage imageWithCGImage:imgRef];
    NSData *normData = UIImagePNGRepresentation(img);
    [normData writeToFile:path atomically:YES];
    
    //CGContextRef imgRef = CGBitmapContextCreate(normalBytes, _width, _height, 8, 4*_width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault);
}

- (NSError *)loadNormalMap
{
    UIImage *normImg = [UIImage imageNamed:@"normal.png"];
    CGImageRef imageRef = [normImg CGImage];
    _width = CGImageGetWidth(imageRef);
    _height = CGImageGetHeight(imageRef);
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    NSData *data = (__bridge id)CGDataProviderCopyData(provider);
    Byte *_normData = (Byte *)[data bytes];
    
    for (int i = 0; i < _width * _height; i++) {
        _vertics[i].normal = (NGLvec3){
            _normData[i*4] * 1.0 / 1000000.0,
            _normData[i*4+1] * 1.0 / 1000000.0,
            _normData[i*4+2] * 1.0 / 1000000.0
        };
    }
    
    return nil;
}

#pragma mark -
//**********************************************************************************************************
//
//	读取路径
//
//  从高度图中读取路径并保存。
//
//**********************************************************************************************************
#pragma mark 寻径相关

- (void)generateRoute
{
    WayPoint *_path = &(WayPoint){
        0,
        nil
    };
    Byte start = 15;
    
    for (int i = 0; i < _width * _height; i++) {
        if (_heightData[i] == start) {
            _path->index = i;
            _heightData[i] = 29;
            break;
        }
    }
    
    WayPoint *now = _path;
    int preIndex = now->index;
    now->next = (WayPoint *)calloc(1, sizeof(WayPoint));
    while ([self findWayPoint:(now->index) previous:preIndex next:now->next]) {
        //[self findWayPoint:now->index previous:preIndex next:now->next];
        preIndex = now->index;
        //printf("Node found:%d\n", now->index);
        now = now->next;
        now->next = (WayPoint *)calloc(1, sizeof(WayPoint));
    }
    now->next = nil;
    
    now = _path;
    int len = 0;
    while (now->next) {
        len += 1;
        now = now->next;
    }
    _routeLength = len;
    _route = (int*)calloc(_routeLength, sizeof(int));
    now = _path;
    int i = 0;
    while (now->next) {
        //printf("Node found:%d\n", now->index);
        _route[i] = now->index;
        i += 1;
        now = now->next;
    }
}

- (void)showIndex:(int)i
{
    if (i >= _width * _height || i < 0) {
        printf("Index out of bound\n");
    }
}

- (BOOL)findWayPoint:(int)index previous:(int)pre next:(WayPoint *)next
{
    //printf("Index: %d\n", index);
    Byte p = 22;

    // 正方向——右、左、下、上
    [self showIndex:index + 1];
    if (_heightData[index + 1] == p && (index + 1) != pre) {
        //printf("Index: %d\n", index);
        *next = (WayPoint){
            index + 1,
            nil
        };
        _heightData[index + 1] = 29;
        return YES;
    }
    
    [self showIndex:index - 1];
    if (_heightData[index - 1] == p && (index - 1) != pre) {
        *next = (WayPoint){
            index - 1,
            nil
        };
        _heightData[index - 1] = 29;
        return YES;
    }
    
    [self showIndex:index + _width];
    if (_heightData[index + _width] == p && (index + _width) != pre) {
        *next = (WayPoint){
            index + _width,
            nil
        };
        _heightData[index + _width] = 29;
        return YES;
    }
    
    [self showIndex:index - _width];
    if (_heightData[index - _width] == p && (index - _width) != pre) {
        *next = (WayPoint){
            index - _width,
            nil
        };
        _heightData[index - _width] = 29;
        return YES;
    }
    
    //NSLog(@"斜方向！！！！！！！");
    // 斜方向——右下、左下、右上、左上
    [self showIndex:index + _width + 1];
    if (_heightData[index + _width + 1] == p && (index + _width + 1) != pre) {
        *next = (WayPoint){
            index + _width + 1,
            nil
        };
        _heightData[index + _width + 1] = 29;
        return YES;
    }
    
    [self showIndex:index + _width - 1];
    if (_heightData[index + _width - 1] == p && (index + _width - 1) != pre) {
        *next = (WayPoint){
            index + _width - 1,
            nil
        };
        _heightData[index + _width - 1] = 29;
        return YES;
    }
    
    [self showIndex:index - _width + 1];
    if (_heightData[index - _width + 1] == p && (index - _width + 1) != pre) {
        *next = (WayPoint){
            index - _width + 1,
            nil
        };
        _heightData[index - _width + 1] = 29;
        return YES;
    }
    
    [self showIndex:index - _width - 1];
    if (_heightData[index - _width - 1] == p && (index - _width - 1) != pre) {
        *next = (WayPoint){
            index - _width - 1,
            nil
        };
        _heightData[index - _width - 1] = 29;
        return YES;
    }
    
    return NO;
}

- (void)loadTexCoor
{
    UIImage *normImg = [UIImage imageNamed:@"1textureMap.png"];
    CGImageRef imageRef = [normImg CGImage];
    _width = CGImageGetWidth(imageRef);
    _height = CGImageGetHeight(imageRef);
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    NSData *data = (__bridge id)CGDataProviderCopyData(provider);
    Byte *_texData = (Byte *)[data bytes];
    
    for (int i = 0; i < _width * _height; i++) {
        _vertics[i].texCoor = (NGLvec2){
            _texData[i*4] * 1.0 / 10.0,
            _texData[i*4+1] * 1.0 / 10.0,
        };
        //printf("Texture coordinates:(%f, %f)\n", _texData[i*4] * 1.0 / 255.0 / 10.0, _texData[i*4+1] * 1.0 / 255.0 / 10.0);
    }
}

@end
