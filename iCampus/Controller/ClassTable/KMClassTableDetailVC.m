//
//  KMClassTableDetailVC.m
//  BISTUEduMgmt
//
//  Created by Kwei Ma on 14-8-24.
//  Copyright (c) 2014年 KWEIMA. All rights reserved.
//

#import "KMClassTableDetailVC.h"
#import "KMClassTableModel.h"

@interface KMClassTableDetailVC ()

@property (strong, nonatomic) IBOutlet UIControl *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditPointLabel;
@property (weak, nonatomic) IBOutlet UILabel *studyHoursLabel;

@end

@implementation KMClassTableDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // data start
    _courseNameLabel.text = _course.courseName;
    _timeLabel.text = _course.timeInStr;
    _placeLabel.text = @"NULL";
    _teacherLabel.text = _course.teacherName;
    _creditPointLabel.text = _course.creditPoint;
    _studyHoursLabel.text = _course.studyHours;
    
    // data end
    
    self.container.layer.cornerRadius = 2.5;
    CGRect sFrame = [[UIScreen mainScreen] bounds];
    self.container.frame = CGRectMake(20.0, 100.0, 280.0, 222.0);
    self.container.alpha = 0.0;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundView.alpha = 1.0;
                         self.container.frame = CGRectMake(20, (sFrame.size.height - 240.0) / 2, 280.0, 222.0);
                         self.container.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    // If the touch was in the placardView, move the placardView to its location
    if ([touch view] == self.container) {
        CGPoint location = [touch locationInView:self.backgroundView];
        self.container.center = location;
        return;
    }
}

- (IBAction)dismissByTappingBackgroung:(UIControl *)sender
{
    CGRect frame = CGRectMake(20.0, 100.0, 280.0, 222.0);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.backgroundView.alpha = 0.0;
                         self.container.frame = frame;
                         self.container.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end
