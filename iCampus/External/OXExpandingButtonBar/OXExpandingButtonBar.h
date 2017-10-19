//
//  OXExpandingButton.h
//  OXExpandingButton
//
//  Created by Cloudox on 15/12/8.
//  Copyright (c) 2015年 Cloudox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OXExpandingButtonBar : UIView
{
    /* ----------------------------------------------
     * 以下属性为可设置属性
     * --------------------------------------------*/
    float _mainRotate;// 主按钮点击展开时旋转到的角度
    float _mainReRotate;// 主按钮点击收回时旋转到的角度
    BOOL _isAnimated;// 子按钮弹出收回是否动画
    BOOL _isSpin;// 子按钮是否旋转
    float _endY;// 子按钮最终位置之间的高度距离
    float _farY;// 子按钮弹出动画弹到的最远高度距离
    float _nearY;// 子按钮弹出动画反弹时的最近高度距离
    float _mainAlpha;// 主按钮未展开时的alpha值
    float _mainAnimationTime;// 主按钮旋转动画时间
    float _subAnimationTime;// 子按钮弹出和旋转动画时间
    float _delay;// 子按钮之间的间隔时间；也影响主按钮延迟改变透明度的时间
}

/* ----------------------------------------------
 * 以下属性为全局使用的属性
 * --------------------------------------------*/
@property BOOL isExpanding;// 是否点击过
@property (strong, nonatomic) UIButton *mainBtn;// 主按钮
@property (strong, nonatomic) NSArray *buttonArray;// 弹出的按钮数组

/**
 * 初始化bar
 * 参数：mainButton:主按钮；buttons：子按钮数组；center：中心点
**/
- (id) initWithMainButton:(UIButton*)mainButton
                  buttons:(NSArray*)buttons
                   center:(CGPoint)center;

/**
 * 展开子按钮
 **/
- (void)showButtonsAnimated:(BOOL)animated;

/**
 * 收起子按钮
 **/
- (void) hideButtonsAnimated:(BOOL)animated;


/* ----------------------------------------------
 * 以下方法用来设置属性
 * --------------------------------------------*/
/**
 * 设置展开时主按钮旋转到的角度
 **/
- (void)setMainRotate:(float)rotate;

/**
 * 设置收起时主按钮旋转到的角度
 **/
- (void)setMainReRotate:(float)rotate;

/**
 * 设置弹出子按钮时是否旋转子按钮
 **/
- (void)setSpin:(BOOL)b;

/**
 * 设置子按钮弹出收回是否动画
 **/
- (void)setAnimated:(BOOL)animated;

/**
 * 设置子按钮最终位置之间的高度距离
 **/
- (void)setEndY:(float)endy;

/**
 * 设置子按钮弹出动画弹到的最远高度距离
 **/
- (void)setFarY:(float)fary;

/**
 * 设置子按钮弹出动画反弹时的最近高度距离
 **/
- (void)setNearY:(float)neary;

/**
 * 设置主按钮未展开时的alpha值
 **/
- (void)setMainAlpha:(float)alpha;

/**
 * 设置主按钮旋转动画时间
 **/
- (void)setMainAnimationTime:(float)time;

/**
 * 设置子按钮弹出和旋转动画时间
 **/
- (void)setSubAnimationTime:(float)time;

/**
 * 设置子按钮之间的间隔时间；也影响主按钮延迟改变透明度的时间
 **/
- (void)setDelay:(float)time;

@end
