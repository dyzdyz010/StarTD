/*
 *	XYZViewController.h
 *	Assignment1
 *	
 *	Created by 刘萌 on 13-7-5.
 *	Copyright 2013年 __MyCompanyName__. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "SingerBullet.h"
#import "CSmoke.h"
#import "AreaAttract.h"
#import "AttractFire.h"
@interface XYZViewController : UIViewController <NGLViewDelegate>
{
struct BillboardRotate
{
    double Rotate_x;
    double Rotate_y;
    double Rotate_z;
};
@private
    NGLCamera *_camera;
    int time;
    int flag;
   
    SingerBullet *m_singlebullet;
    float rotateY;
    float bulletmovetime;
     NGLvec3 star, end;
       
    //-------------设置烟雾效果所需的变量----------------//
    float smokealpha;
    CSmoke *_test1;
    
    //------------范围攻击----------//
    AreaAttract *m_areabullet;
    
    
    //-------------爆炸效果--------------//
    AttractFire *m_exposion;
    
    //-----------公告板测试----------//
    CSmoke *_tree;
}

- (IBAction)MoveStar:(id)sender;

@end
