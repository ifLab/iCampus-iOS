//
//  ICViewController.m
//  iCampus
//
//  Created by Kwei Ma on 13-11-6.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "ICGateViewController.h"

#define MSGBTN_NORMAL 1001
#define MSGBTN_HIGHLIGHTED 1002

@interface ICGateViewController ()

@end

@implementation ICGateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"iCampus";
    self.naviBarMsnBtn.tag = MSGBTN_NORMAL;
    
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkMessage:(id)sender
{
    if (self.naviBarMsnBtn.tag == MSGBTN_NORMAL) {
        self.naviBarMsnBtn.image = [UIImage imageNamed:@"NaviBarMsgBtnHighlighted.png"];
        self.naviBarMsnBtn.tag = MSGBTN_HIGHLIGHTED;
    }
    else
    {
        self.naviBarMsnBtn.image = [UIImage imageNamed:@"NaviBarMsgBtnNormal.png"];
        self.naviBarMsnBtn.tag = MSGBTN_NORMAL;
    }
}

- (IBAction)pressedSettingBtn:(id)sender
{
}
@end
