//
//  SingerBullet.h
//  Assignment1
//
//  Created by 刘萌 on 13-7-7.
//
//

#import <UIKit/UIKit.h>
#import "CSmoke.h"

@interface SingerBullet: NGLObject3D
{
enum bulletType
{
    RED_SMALL_BULLET,
    RED_BIG_BULLET,
};
    
enum velocitychange{
    ACCELERATE,
    DECELERATE,
    CONSTANT
};
     
@private
    int bulletnum;
    NGLMesh *_bullet_mesh;
    //---------------运动属性---------------//
    NGLvec3 m_starpos;
    NGLvec3 m_endpos;
    NGLvec3 m_distance;
    NGLvec3 m_pos;
    NGLvec3 m_bullet_a;
    NGLvec3 m_bullet_v;
    float movetime, act_movetime, test;   //子弹运行时间
    float m_vy_change, m_vz_change;  //子弹的速度
    float period; //定义子弹运行一个周期
    float m_size; //定义子弹的大小

    //---------------烟雾-----------------//
    CSmoke *bullet_smokes[10];
    NSMutableArray *smokearray;
}

- (void) InitBulletType: (GLint)type StarPos: (NGLvec3)starpos EndPos: (NGLvec3)enpos Setting: (NSDictionary*)setting;

- (NGLMesh*) GetMesh;
- (NSMutableArray*) GetSmokeArray;
- (float) GetBulletMovetime;
- (void) MoveBullet: (GLint)time;
//- (int) VelocityChange: (GLint)time;

@end
