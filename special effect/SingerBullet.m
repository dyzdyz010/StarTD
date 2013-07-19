//
//  SingerBullet.m
//  Assignment1
//
//  Created by 刘萌 on 13-7-7.
//
//

#import "SingerBullet.h"
#define VX 0.01
#define VY 0.00
#define VZ 0.00

#define FREQUENCY 0.005
#define AMPLITUDE 0.1

#define DIVISION 100
#define HALF 0.5
#define STARTIME 0
#define PI 3.1415926

@implementation SingerBullet

- (void) InitBulletType: (GLint)type StarPos: (NGLvec3)starpos EndPos: (NGLvec3)endpos Setting: (NSDictionary*)settings
{
    m_distance.x = endpos.x - starpos.x;
    m_distance.y = endpos.y - starpos.y;
    m_distance.z = endpos.z - starpos.z;
    
    m_starpos.x = starpos.x;
    m_starpos.y = starpos.y;
    m_starpos.z = starpos.z;
    
    m_endpos.x = endpos.x;
    m_endpos.y = endpos.y;
    m_endpos.z = endpos.z;
    
    m_pos.x = starpos.x;
    m_pos.y = starpos.y;
    m_pos.z = starpos.z;
    
    m_bullet_v.x = VX;  //确定子弹在X轴方向上的运行时间
    period = m_distance.x/m_bullet_v.x;  //求出子弹运行时间
    m_bullet_v.y = m_distance.y/period;
    m_bullet_v.z = m_distance.z/period;
       
    switch (type) {
        case RED_BIG_BULLET:
            _bullet_mesh = [[NGLMesh alloc] initWithFile:@"cube.obj" settings:settings delegate:nil];
            m_size = 0.04;
            break;
        case RED_SMALL_BULLET:
            _bullet_mesh = [[NGLMesh alloc] initWithFile:@"cube.obj" settings:settings delegate:nil];
            m_size = 0.01;
        default:
            break;
    }
    
    _bullet_mesh.x = m_pos.x;
    _bullet_mesh.y = m_pos.y;
    _bullet_mesh.z = m_pos.z;
    
    _bullet_mesh.scaleX = m_size*2;
    _bullet_mesh.scaleY = m_size;
    _bullet_mesh.scaleZ = m_size;
    
    //---------------smoke codo----------------//
    for (int i=0; i<10; i++) {
        bullet_smokes[i] = [[CSmoke alloc] init];
        [bullet_smokes[i] InitSmokeText:@"smoke.png" Setting:settings BulletSize:0.01];
    }

    smokearray = [[NSMutableArray alloc] init];
}

-(NSMutableArray*) GetSmokeArray
{
    NGLMesh *_temp;
    for (int i=0; i<10; i++) {
        _temp = [bullet_smokes[i] GetSmokeMesh];
        _temp.visible = FALSE;
        [smokearray addObject:_temp];
    }
    return smokearray;
}

-
(float) GetBulletMovetime
{
    return period;
}

//在此添加传入变量 时间
- (void) MoveBullet: (GLint) time
{
    act_movetime = time - STARTIME;
    
    m_bullet_a.y = -FREQUENCY*FREQUENCY*AMPLITUDE*sin(2*(act_movetime/DIVISION)*2*PI);
    m_bullet_a.z = -FREQUENCY*FREQUENCY*AMPLITUDE*sin(2*(act_movetime/DIVISION)*2*PI);
    
    m_vy_change = FREQUENCY*AMPLITUDE*cos(2*(act_movetime/DIVISION)*2*PI);
    m_vz_change = FREQUENCY*AMPLITUDE*cos(2*(act_movetime/DIVISION)*2*PI);

    m_pos.x = m_starpos.x + m_bullet_v.x * act_movetime;
    m_pos.y = AMPLITUDE*sin(4*(act_movetime/DIVISION)*2*PI) + m_bullet_v.y*act_movetime;
    m_pos.z = AMPLITUDE*sin(4*(act_movetime/DIVISION)*2*PI) + m_bullet_v.z*act_movetime;
   
    _bullet_mesh.x = m_pos.x;
    _bullet_mesh.y = m_pos.y;
    _bullet_mesh.z = m_pos.z;
    
    //-----------------------十个烟雾的初始化----------------------------//
    int act_movetime_int = act_movetime;
    
    if (act_movetime <= 10) {
        [bullet_smokes[act_movetime_int-1] GetSmokeMesh].visible = TRUE;
        [bullet_smokes[act_movetime_int-1] SetSmokePos:m_pos];
        [bullet_smokes[act_movetime_int-1] SetAlpha:1.0f];
    }
    
    int smoketime;
    if (act_movetime > 10) {
        smoketime = act_movetime_int%10;
    }
    else
        smoketime = act_movetime;
   
    if (smoketime == 0) {
        smoketime = 10;
    }
    //-------------smoketime [1, 10]---------------//
    
    for (int i=0; i<10; i++) {
        [bullet_smokes[i] RenderSmoke:(10+i-smoketime)*1.0/10];
        
        if ([bullet_smokes[i] GetAlpha] < 0.1f) {
            [bullet_smokes[i] SetSmokePos:m_pos];
            [bullet_smokes[i] RenderSmoke:0.9];
        }
    }
    
}

//- (int)VelocityChange:(GLint)time
//{
//    test  = time;
//    
//    if(time < 5 || time >= 45)
//        return CONSTANT;
//    else if( (5<=time && time<10) || (20<=time && time<25) || (30<=time && time<40))
//        return ACCELERATE;
//    else if((10<=time && time<20) || (25<=time && time<30) || (40<=time && time<45))
//        return DECELERATE;
//}

- (NGLMesh*) GetMesh
{
    return _bullet_mesh;
}

- (void) dealloc
{
    [_bullet_mesh release];
    for (int i=0; i<10; i++) {
        [bullet_smokes[i] release];
    }
    [smokearray release];
    [super dealloc];
}












@end
