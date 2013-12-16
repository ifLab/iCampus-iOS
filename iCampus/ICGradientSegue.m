//
//  ICGradientSegue.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-7.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICGradientSegue.h"

@implementation ICGradientSegue

- (void)perform
{
    UIViewController *destVC = (UIViewController *)[self destinationViewController];
    destVC.view.alpha = 0;
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         destVC.view.alpha = 1.0;
                     }
                     completion:nil];
    
    [[self sourceViewController] presentViewController:[self destinationViewController] animated:NO completion:nil];
}

@end
