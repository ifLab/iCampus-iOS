//
//  OXExpandingButton.m
//  OXExpandingButton
//
//  Created by Cloudox on 15/12/8.
//  Copyright (c) 2015年 Cloudox. All rights reserved.
//

#import "OXExpandingButtonBar.h"

@implementation OXExpandingButtonBar

- (id) initWithMainButton:(UIButton*)mainButton buttons:(NSArray*)buttons center:(CGPoint)center {
    if (self = [super init]) {
        [self setDefaults];// 设置默认数值
        
        CGRect buttonFrame = CGRectMake(0, 0, mainButton.frame.size.width, mainButton.frame.size.height);
        CGPoint buttonCenter = CGPointMake(mainButton.frame.size.width / 2.0f, mainButton.frame.size.height / 2.0f);
        
        self.isExpanding = NO;
        
        // 主按钮
        self.mainBtn = mainButton;
        [self.mainBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainBtn setCenter:buttonCenter];
        _mainAlpha = self.mainBtn.alpha;
        
        // 子按钮
        self.buttonArray = [[buttons reverseObjectEnumerator] allObjects];
        for (int i = 0; i < [self.buttonArray count]; i++) {
            UIButton *button = [self.buttonArray objectAtIndex:i];
            [button setCenter:buttonCenter];
            [button setAlpha:0.0f];
            [self addSubview:button];
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFrame:buttonFrame];
        [self setCenter:center];
        [self addSubview:self.mainBtn];
    }
    return self;
}

// 设置默认数值
- (void)setDefaults {
    /*关于M_PI
     #define M_PI     3.14159265358979323846264338327950288
     其实它就是圆周率的值，在这里代表弧度，相当于角度制 0-360 度，M_PI=180度
     旋转方向为：顺时针旋转
     */
    
    _mainRotate = - M_PI*(45)/180.0f;
    _mainReRotate = 0.0f;
    _isSpin = YES;
    _isAnimated = YES;
    _endY = 30.0f;
    _farY = 30.0f;
    _nearY = 15.0f;
    _mainAnimationTime = 0.3f;
    _subAnimationTime = 0.4f;
    _delay = 0.1f;
}

// 点击主按钮的响应
- (void)btnTap:(UIButton *)sender {
    if (!self.isExpanding) {// 初始未展开
        [self showButtonsAnimated:_isAnimated];
    } else {// 已展开
        [self hideButtonsAnimated:_isAnimated];
    }
}

// 展开按钮
- (void)showButtonsAnimated:(BOOL)animated {
    // 主按钮旋转动画
    if (animated) {
        CGAffineTransform angle = CGAffineTransformMakeRotation (_mainRotate);
        [UIView animateWithDuration:_mainAnimationTime animations:^{// 动画开始
            [self.mainBtn setTransform:angle];
        } completion:^(BOOL finished){// 动画结束
            [self.mainBtn setTransform:angle];
        }];
    } else {
        CGAffineTransform angle = CGAffineTransformMakeRotation (_mainRotate);
        [self.mainBtn setTransform:angle];
    }
    
    float y = [self.mainBtn center].y;
    float x = [self.mainBtn center].x;
    float endY = y;
    float endX = x;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        // 最终坐标
        endY -= button.frame.size.height + _endY;
        endX += 0.0f;
        // 反弹坐标
        float farY = endY - _farY;
        float farX = endX - 0.0f;
        float nearY = endY + _nearY;
        float nearX = endX + 0.0f;
        
        if (animated) {
            // 动画集合
            NSMutableArray *animationOptions = [NSMutableArray array];
            
            if (_isSpin) {// 旋转动画
                CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2], nil]];
                [rotateAnimation setDuration:_subAnimationTime];
                [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
                [animationOptions addObject:rotateAnimation];
            }
            
            // 位置动画
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [positionAnimation setDuration:_subAnimationTime];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, x, y);
            CGPathAddLineToPoint(path, NULL, farX, farY);
            CGPathAddLineToPoint(path, NULL, nearX, nearY);
            CGPathAddLineToPoint(path, NULL, endX, endY);
            [positionAnimation setPath: path];
            CGPathRelease(path);
            [animationOptions addObject:positionAnimation];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            [animationGroup setAnimations: animationOptions];
            [animationGroup setDuration:_subAnimationTime];
            [animationGroup setFillMode: kCAFillModeForwards];
            [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            
            NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, [NSValue valueWithCGPoint:CGPointMake(endX, endY)], animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"center", @"animation", nil]];
            
            [self performSelector:@selector(_expand:) withObject:properties afterDelay:_delay * ([self.buttonArray count] - i)];
        } else {
            [button setCenter:CGPointMake(endX, endY)];
            [button setAlpha:1.0f];
        }
        
    }
    self.isExpanding = YES;// 设为已展开
    if (animated) {
        [self performSelector:@selector(changeMainAlpha) withObject:nil afterDelay:_delay * [self.buttonArray count]];
    } else {
        self.mainBtn.alpha = 1.0f;
    }
    
}

// 收起动画
- (void) hideButtonsAnimated:(BOOL)animated {
    // 主按钮旋转动画
    if (animated) {
        CGAffineTransform unangle = CGAffineTransformMakeRotation (_mainReRotate);
        [UIView animateWithDuration:_mainAnimationTime animations:^{// 动画开始
            [self.mainBtn setTransform:unangle];
        } completion:^(BOOL finished){// 动画结束
            [self.mainBtn setTransform:unangle];
        }];
    } else {
        CGAffineTransform unangle = CGAffineTransformMakeRotation (_mainReRotate);
        [self.mainBtn setTransform:unangle];
    }
    
    CGPoint center = [self.mainBtn center];
    float endY = center.y;
    float endX = center.x;
    for (int i = 0; i < [self.buttonArray count]; ++i) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        
        if (animated) {
            // 动画集合
            NSMutableArray *animationOptions = [NSMutableArray array];
            
            if (_isSpin) {// 旋转动画
                CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
                [rotateAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * -2], nil]];
                [rotateAnimation setDuration:_subAnimationTime];
                [rotateAnimation setKeyTimes:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:1.0f], nil]];
                [animationOptions addObject:rotateAnimation];
            }
            
            // 透明度？
            CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            [opacityAnimation setValues:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:0.0f], nil]];
            [opacityAnimation setDuration:_subAnimationTime];
            [animationOptions addObject:opacityAnimation];
            
            // 位置动画
            float y = [button center].y;
            float x = [button center].x;
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [positionAnimation setDuration:_subAnimationTime];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, x, y);
            CGPathAddLineToPoint(path, NULL, endX, endY);
            [positionAnimation setPath: path];
            CGPathRelease(path);
            [animationOptions addObject:positionAnimation];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            [animationGroup setAnimations: animationOptions];
            [animationGroup setDuration:_subAnimationTime];
            [animationGroup setFillMode: kCAFillModeForwards];
            [animationGroup setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            
            NSDictionary *properties = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:button, animationGroup, nil] forKeys:[NSArray arrayWithObjects:@"view", @"animation", nil]];
            [self performSelector:@selector(_close:) withObject:properties afterDelay:_delay * ([self.buttonArray count] - i)];
        } else {
            [button setCenter:center];
            [button setAlpha:0.0f];
        }
        
    }
    self.isExpanding = NO;// 设为未展开
    if (animated) {
        [self performSelector:@selector(changeMainAlpha) withObject:nil afterDelay:_delay * [self.buttonArray count]];
    } else {
        self.mainBtn.alpha = _mainAlpha;
    }
    
}

// 弹出
- (void) _expand:(NSDictionary*)properties
{
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    NSValue *val = [properties objectForKey:@"center"];
    CGPoint center = [val CGPointValue];
    [[view layer] addAnimation:animationGroup forKey:@"Expand"];
    [view setCenter:center];
    [view setAlpha:1.0f];
}

// 收起
- (void) _close:(NSDictionary*)properties
{
    UIView *view = [properties objectForKey:@"view"];
    CAAnimationGroup *animationGroup = [properties objectForKey:@"animation"];
    CGPoint center = [self.mainBtn center];
    [[view layer] addAnimation:animationGroup forKey:@"Collapse"];
    [view setAlpha:0.0f];
    [view setCenter:center];
}

// 改变主按钮alpha
- (void) changeMainAlpha {
    if (self.isExpanding) {// 已展开
        self.mainBtn.alpha = 1.0f;
    } else {
        self.mainBtn.alpha = _mainAlpha;
    }
}


/* ----------------------------------------------
 * 以下方法为设置时用到的方法
 * --------------------------------------------*/
- (void)setMainRotate:(float)rotate {
    _mainRotate = rotate;
}

- (void)setMainReRotate:(float)rotate {
    _mainReRotate = rotate;
}

- (void)setSpin:(BOOL)b {
    _isSpin = b;
}

- (void)setAnimated:(BOOL)animated {
    _isAnimated = animated;
}

- (void)setEndY:(float)endy {
    _endY = endy;
}

- (void)setFarY:(float)fary {
    _farY = fary;
}

- (void)setNearY:(float)neary {
    _nearY = neary;
}

- (void)setMainAlpha:(float)alpha {
    _mainAlpha = alpha;
}

- (void)setMainAnimationTime:(float)time {
    _mainAnimationTime = time;
}

- (void)setSubAnimationTime:(float)time {
    _subAnimationTime = time;
}

- (void)setDelay:(float)time {
    _delay = time;
}


/* ----------------------------------------------
 * DO NOT CHANGE
 * The following is a hack to allow touches outside
 * of this view. Use caution when changing.
 * --------------------------------------------*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = nil;
    v = [super hitTest:point withEvent:event];
    return v;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isInside = [super pointInside:point withEvent:event];
    if (YES == isInside) {
        return isInside;
    }
    for (UIButton *button in self.buttonArray) {
        CGPoint inButtonSpace = [self convertPoint:point toView:button];
        BOOL isInsideButton = [button pointInside:inButtonSpace withEvent:nil];
        if (YES == isInsideButton) {
            return isInsideButton;
        }
    }
    return isInside;
}


@end
