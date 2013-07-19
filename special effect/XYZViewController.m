/*
 *	XYZViewController.m
 *	Assignment1
 *	
 *	Created by 刘萌 on 13-7-5.
 *	Copyright 2013年 __MyCompanyName__. All rights reserved.
 */

#import "XYZViewController.h"
#define PI 3.1415926
#pragma mark -
#pragma mark Constants
#pragma mark -
//**********************************************************************************************************
//
//	Constants
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Private Interface
#pragma mark -
//**********************************************************************************************************
//
//	Private Interface
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Public Interface
#pragma mark -
//**********************************************************************************************************
//
//	Public Interface
//
//**********************************************************************************************************

@implementation XYZViewController

#pragma mark -
#pragma mark Properties
//**************************************************
//	Properties
//**************************************************

#pragma mark -
#pragma mark Constructors
//**************************************************
//	Constructors
//**************************************************

#pragma mark -
#pragma mark Private Methods
//**************************************************
//	Private Methods
//**************************************************

#pragma mark -
#pragma mark Self Public Methods
//**************************************************
//	Self Public Methods
//**************************************************

- (void) drawView
{
    if(flag  == 1)  //点击按钮开始动
    {
    
    if(time < bulletmovetime)  //bulletmovetime是下面用方法获取的 是子弹运行的时间
        time ++;
    else
        time = 1;   //子弹回到起始点 继续
         
    [m_singlebullet MoveBullet:time];  //更新子弹的位置
       
        
////------------此段代码用来移除旧mesh加入新的mesh--------------//
        //------这个是爆炸效果的 移除前一个mesh加入新的mesh-------//
//        [_camera removeMesh:[m_exposion GetMesh]];
//        [m_exposion UpdateTexture:time];
//        [_camera addMesh:[m_exposion GetMesh]];
        
////------------此段代码用来移除旧mesh加入新的mesh--------------//
        //------这个是范围攻击 闪电效果的 移除前一个mesh加入新的mesh-------//
//        [_camera removeMesh:[m_areabullet GetMesh]];
//        [m_areabullet UpdateTexture:time];
//        [_camera addMesh:[m_areabullet GetMesh]];
    
    }
    
    [_camera drawCamera];
    
}

#pragma mark -
#pragma mark Override Public Methods
//**************************************************
//	Override Public Methods
//**************************************************

- (void) viewDidLoad
{
	// Must call super to agree with the UIKit rules.
	[super viewDidLoad];
	flag = 0;
    time = 0;
    smokealpha = 0.0f;
	// Setting the loading process parameters. To take advantage of the NGL Binary feature,
	// remove the line "kNGLMeshOriginalYes, kNGLMeshKeyOriginal,". Your mesh will be loaded 950% faster.
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  kNGLMeshOriginalYes, kNGLMeshKeyOriginal,
							  kNGLMeshCentralizeYes, kNGLMeshKeyCentralize,
							  @"0.3", kNGLMeshKeyNormalize,
							  nil];
   
    star.x = -0.25f; star.y = 0.0f; star.z = 0.0f;
    end.x = 0.25f; end.y = 0.25f; end.z = 0.0f;
    
     _camera = [[NGLCamera alloc] init];
    //----------------------------初始化一颗子弹------------------------------//
    m_singlebullet = [[SingerBullet alloc] init];
    [m_singlebullet InitBulletType:RED_SMALL_BULLET StarPos:star EndPos:end Setting:settings];
    bulletmovetime = [m_singlebullet GetBulletMovetime];  //获取子弹运行时间
    [_camera addMesh:[m_singlebullet GetMesh]];
    [_camera addMeshesFromArray:[m_singlebullet GetSmokeArray]];

//
//    //-----------------------初始化范围攻击 即闪电效果---------------------------//
//    m_areabullet = [[AreaAttract alloc]init];
//    [m_areabullet InitAreaAttractStarPos:star EndPos:end Setting:settings];
//    [_camera addMesh:[m_areabullet GetMesh]];
//    
//     //---------------------------初始化爆炸效果-------------------------------//
//    m_exposion = [[AttractFire alloc]init];
//    [m_exposion InitExposionPos:star Setting:settings];

    [_camera lookAtPointX:0 toY:0 toZ:0];
	[_camera autoAdjustAspectRatio:YES animated:YES];
    
    // Starts the debug monitor.
	[[NGLDebug debugMonitor] startWithView:(NGLView *)self.view];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (IBAction)MoveStar:(id)sender {
    flag = 1;
}

@end

















